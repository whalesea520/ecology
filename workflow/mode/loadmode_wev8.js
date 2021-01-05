var showwidth=0;
var showheight=0;
var nowcol=1;
var nowrow=1;
function getwidth(){
	var swidth=0;
	showwidth=0;
	var i=0;
	nowcol=document.frmmain.ChinaExcel.GetSelectRegionStartCol();
	var startCol = document.frmmain.ChinaExcel.GetStartCol();
	
	if(!frmmain.ChinaExcel.ShowHeader){
		i=1 ;
	}
	i = (startCol - 1) + i;
	for (i ; i <nowcol; i++){
		swidth=document.frmmain.ChinaExcel.GetColSize(i,1);
		showwidth+=swidth;
	}
}
function getHeight(){
	var sheight=0;
	showheight=0;
	var j=0;
	nowrow=document.frmmain.ChinaExcel.GetSelectRegionStartRow();
	if(!frmmain.ChinaExcel.ShowHeader){
		j=1;
	}
	for(j;j <nowrow; j++){
		sheight=document.frmmain.ChinaExcel.GetRowSize(j,1);
		showheight+=sheight;
	}
}
function mouseout(){
	var x = oPopup.document.parentWindow.event.clientX;
	var y = oPopup.document.parentWindow.event.clientY
	if(x<0 || y<0) window.setTimeout("oPopup.hide()",1000);
}
var oPopup = window.createPopup();
var oPopupInprepDspDate = window.createPopup();
var lefter =0;
var topper =0;
function showPopup(uservalue,cellvalue,ismand,selectshow)
{
    if(uservalue!=null && uservalue!="" && uservalue.lastIndexOf("_")>-1 && ismand>=0){
        if(uservalue=="main_createCodeAgain"){
			showPopupCreateCodeAgain(uservalue,cellvalue,ismand,selectshow);
			return ;
		}

		var fieldBodyId=0;
		var isedit=0;
		if(ismand>0){
			isedit=1;
		}
		if(uservalue.indexOf("_")>5){
			fieldBodyId=uservalue.substring(5,uservalue.indexOf("_"));
		}

		var flowDocField=-1;
		var newTextNodes;
		if($G("flowDocField")!=null){
			flowDocField=$G("flowDocField").value;
		}

		if($G("newTextNodes") != null){
		   newTextNodes = $G("newTextNodes").value;
		}

		
        var htmltype=uservalue.substring(uservalue.lastIndexOf("_")+1);
        uservalue=uservalue.substring(0,uservalue.lastIndexOf("_"));
        var fieldtype=0;
        if(uservalue.lastIndexOf("_")>-1){
            fieldtype=uservalue.substring(uservalue.lastIndexOf("_")+1);
            uservalue=uservalue.substring(0,uservalue.lastIndexOf("_"));
        }
   
		var resourceRoleId="-1";	
		if($G("resourceRoleId"+uservalue)!=null){
			resourceRoleId=$G("resourceRoleId"+uservalue).value;
		}

		getwidth();
        getHeight();
        if(!frmmain.ChinaExcel.ShowHeader){
           showwidth=showwidth;
        }else{
           showwidth=showwidth-20;
        }
        lefter =showwidth;
        topper =frmmain.ChinaExcel.GetMousePosY();
        var isreadonly=isHiddenPop(uservalue);
        if(htmltype=="3"){
            var urlid="";
            var url="";
            var urllink="";
            var urllinkno="";
            var i;
            var selvalue=new Array();
            var urlarr=new Array();
            var urlno=new Array();
            var oTable=$G("otable");
            var oDiv;
            var sHtml = "";
            var indexrow=parseInt($G("indexrow").value);
            var requestid="0";
            var desrequestid = "0";
			var userid=$G("f_weaver_belongto_userid").value;
			var usertype=$G("f_weaver_belongto_usertype").value;
			var isbill="";
			var isdetail="";//分权这个参数暂时没有对应的获取
            if(indexrow>0){
                for(i=(indexrow-1);i>=0;i--){
                    oTable.deleteRow(i);
                }
                indexrow=0;
            }
            try{
                if($G(uservalue)){
            		urlid=$G(uservalue).value;
            	}
                var fieldstr=uservalue;
                if(uservalue.indexOf("_")>0){
                    fieldstr=uservalue.substring(0,uservalue.indexOf("_"));
					isdetail="1";
                }
				
				
                if($G(uservalue+"_url")){
                    url = $G(uservalue+"_url").value;
                }
                if (url == "") {
                    url = $G(fieldstr + "_url").value;
                }
                if ($G(uservalue + "_urllink")) {
                    urllink = $G(uservalue + "_urllink").value;

                }
                if (urllink == "") {
                    urllink = $G(fieldstr + "_urllink").value;
                }
                if($G(uservalue+"_linkno")){
                	urllinkno=$G(uservalue+"_linkno").value;
                }
            }catch(e){}
            if($G("requestid")!=null)
                requestid=$G("requestid").value;
              if($G("desrequestid")!=null){
            	desrequestid=$G("desrequestid").value;
            }
 
		 
 
			if(typeof($G("isbill")) != undefined)
			  isbill=$G("isbill").value;
			
			  
			
            if(cellvalue!=null && cellvalue!=""){
                if(cellvalue.indexOf(",")>-1){
                    selvalue=cellvalue.split(",");
                    urlarr=urlid.split(",");
                    urlno=urllinkno.split(",");
                }else{
                    selvalue[0]=cellvalue;
                    urlarr[0]=urlid;
                    urlno[0]=urllinkno;
                }
				oTable.border=1;
                oRow = oTable.insertRow();
                oCell = oRow.insertCell();
                oCell.colSpan =2;
                oCell.style.fontSize="14px";
                oCell.style.color="blue";
                for(i=0;i<selvalue.length;i++){
                    if(sHtml.length>0){
                        sHtml+=" ";
                    }
                    if(urllink!=""){

                        if(fieldtype==9&&fieldBodyId==flowDocField){
                            //sHtml+="<a href='#' onclick=\"this.disabled=true;parent.createDoc('"+fieldBodyId+"','"+urlarr[i]+"','"+isedit+"')\">"+selvalue[i]+"</a>";
							sHtml+="<a href='#' onclick=\"try {this.disabled=true;parent.createDoc('"+fieldBodyId+"','"+urlarr[i]+"','"+isedit+"');}catch(e){parent.window.open('"+urllink+urlarr[i]+"&requestid="+requestid+"&desrequestid="+desrequestid+"')}\">"+selvalue[i]+"</a>";
                        }else if(fieldtype==16 || fieldtype==152 || fieldtype==171){
                            if(urlno[i]!=""&&urlno[i]>-1){
                                sHtml+="<a href='#' onclick=\"parent.window.open('"+urllink+urlarr[i]+"&f_weaver_belongto_userid="+userid+"&f_weaver_belongto_usertype="+usertype+"&wflinkno="+urlno[i]+"')\">"+selvalue[i]+"</a>";
                            }else{
                                sHtml+="<a href='#' onclick=\"parent.window.open('"+urllink+urlarr[i]+"&f_weaver_belongto_userid="+userid+"&f_weaver_belongto_usertype="+usertype+"')\">"+selvalue[i]+"</a>";
                            }
                        }else if(fieldtype==8 || fieldtype==135 || fieldtype==7 || fieldtype==18 || fieldtype==9 || fieldtype==37 || fieldtype==23){
                            sHtml+="<a href='#' onclick=\"parent.window.open('"+urllink+urlarr[i]+"&requestid="+requestid+"&desrequestid="+desrequestid+"&f_weaver_belongto_userid="+userid+"&f_weaver_belongto_usertype="+usertype+"')\">"+selvalue[i]+"</a>";
                        }
                        else
                        {
                             if(urllink=="/hrm/resource/HrmResource.jsp?id=")
                             {
								sHtml +="<a href='#' onclick='javascript:parent.pointerXY(event);parent.openhrm("+urlarr[i]+");'>"+selvalue[i]+"</a>"
							 }
							 else
							 {
                            	sHtml+="<a href='#' onclick=\"parent.openWindow('"+urllink+urlarr[i]+"')\">"+selvalue[i]+"</a>";
                             }
                        }
                    }else{
                        sHtml+=selvalue[i];
                    }
                }
                oDiv = document.createElement("div");
                oDiv.innerHTML = sHtml;
                oCell.appendChild(oDiv);
                indexrow++;
            }
			if(selectshow!=0 && ismand>0){
						
			if(fieldtype == 16){   //请求
if(url.indexOf("RequestBrowser.jsp?")>-1){
	url+="&f_weaver_belongto_userid="+userid+"&f_weaver_belongto_usertype="+usertype;
}else{
	url+="?f_weaver_belongto_userid="+userid+"&f_weaver_belongto_usertype="+usertype;
}
/*if(linkurl.indexOf("ViewRequest.jsp?")>-1){
	linkurl+="&f_weaver_belongto_userid="+userid+"&f_weaver_belongto_usertype="+usertype;
}else{
	linkurl+="?f_weaver_belongto_userid="+userid+"&f_weaver_belongto_usertype="+usertype;
}*/
}

if(fieldtype == 152 || fieldtype ==171){   //多请求



if(url.indexOf("MultiRequestBrowser.jsp?")>-1){
	url+=uescape("&f_weaver_belongto_userid="+userid+"&f_weaver_belongto_usertype="+usertype);
}else{
	url+=uescape("?f_weaver_belongto_userid="+userid+"&f_weaver_belongto_usertype="+usertype);
}
/*if(linkurl.indexOf("ViewRequest.jsp?")>-1){
	linkurl+="&f_weaver_belongto_userid="+userid+"&f_weaver_belongto_usertype="+usertype;
}else{
	linkurl+="?f_weaver_belongto_userid="+userid+"&f_weaver_belongto_usertype="+usertype;
}*/
} 

if(fieldtype == 7){   //客户
if(url.indexOf("CustomerBrowser.jsp?")>-1){
	url+="&f_weaver_belongto_userid="+userid+"&f_weaver_belongto_usertype="+usertype;
}else{
	url+="?f_weaver_belongto_userid="+userid+"&f_weaver_belongto_usertype="+usertype;
}
/*if(linkurl.indexOf("ViewCustomer.jsp?")>-1){
	linkurl+="&f_weaver_belongto_userid="+userid+"&f_weaver_belongto_usertype="+usertype;
}else{
	linkurl+="?f_weaver_belongto_userid="+userid+"&f_weaver_belongto_usertype="+usertype;
}*/
}

if(fieldtype == 9){   //文档
if(url.indexOf("DocBrowser.jsp?")>-1){
	url+="&f_weaver_belongto_userid="+userid+"&f_weaver_belongto_usertype="+usertype;
}else{
	url+="?f_weaver_belongto_userid="+userid+"&f_weaver_belongto_usertype="+usertype;
}
/*if(linkurl.indexOf("DocDsp.jsp?")>-1){
	linkurl+="&f_weaver_belongto_userid="+userid+"&f_weaver_belongto_usertype="+usertype;
}else{
	linkurl+="?f_weaver_belongto_userid="+userid+"&f_weaver_belongto_usertype="+usertype;
}*/
}

if(fieldtype == 37){   //多文档



if(url.indexOf("MutiDocBrowser.jsp?")>-1){
	url+="&f_weaver_belongto_userid="+userid+"&f_weaver_belongto_usertype="+usertype;
}else{
	url+="?f_weaver_belongto_userid="+userid+"&f_weaver_belongto_usertype="+usertype;
}
/*if(linkurl.indexOf("DocDsp.jsp?")>-1){
	linkurl+="&f_weaver_belongto_userid="+userid+"&f_weaver_belongto_usertype="+usertype;
}else{
	linkurl+="?f_weaver_belongto_userid="+userid+"&f_weaver_belongto_usertype="+usertype;
}*/
}


//================================================================================================


if(fieldtype ==1){   //单人力



if(url.indexOf("ResourceBrowser.jsp?")>-1){
	url+="&f_weaver_belongto_userid="+userid+"&f_weaver_belongto_usertype="+usertype;
}else{
	url+="?f_weaver_belongto_userid="+userid+"&f_weaver_belongto_usertype="+usertype;
}
/*if(linkurl.indexOf("HrmResource.jsp?")>-1){
	linkurl+="&f_weaver_belongto_userid="+userid+"&f_weaver_belongto_usertype="+usertype;
}else{
	linkurl+="?f_weaver_belongto_userid="+userid+"&f_weaver_belongto_usertype="+usertype;
}*/


}

/*if(fieldtype == 17){   ////多人力



if(url.indexOf("MultiResourceBrowser.jsp?")>-1){
	url+="&f_weaver_belongto_userid="+userid+"&f_weaver_belongto_usertype="+usertype;
}else{
	url+="?f_weaver_belongto_userid="+userid+"&f_weaver_belongto_usertype="+usertype;
}
/*if(linkurl.indexOf("hrmTab.jsp?")>-1){
	linkurl+="&f_weaver_belongto_userid="+userid+"&f_weaver_belongto_usertype="+usertype;
}else{
	linkurl+="?f_weaver_belongto_userid="+userid+"&f_weaver_belongto_usertype="+usertype;
}
}*/

if(fieldtype ==165){   //分权单人力

 

if(url.indexOf("ResourceBrowserByDec.jsp?")>-1){
	url+="&f_weaver_belongto_userid="+userid+"&f_weaver_belongto_usertype="+usertype+"&fieldid="+fieldBodyId+"&isbill="+isbill+"&isdetail="+isdetail;
}else{
	url+="?f_weaver_belongto_userid="+userid+"&f_weaver_belongto_usertype="+usertype+"&fieldid="+fieldBodyId+"&isbill="+isbill+"&isdetail="+isdetail;
}
/*if(linkurl.indexOf("HrmResource.jsp?")>-1){
	linkurl+="&f_weaver_belongto_userid="+userid+"&f_weaver_belongto_usertype="+usertype;
}else{
	linkurl+="?f_weaver_belongto_userid="+userid+"&f_weaver_belongto_usertype="+usertype;
}*/
 //alert(url);

}

if(fieldtype == 166){   ////分权多人力


	if(url.indexOf("MultiResourceBrowserByDec.jsp?")>-1){
		url+="&f_weaver_belongto_userid="+userid+"&f_weaver_belongto_usertype="+usertype+"&fieldid="+fieldBodyId+"&isbill="+isbill+"&isdetail="+isdetail;
	}else{
		url+="?f_weaver_belongto_userid="+userid+"&f_weaver_belongto_usertype="+usertype+"&fieldid="+fieldBodyId+"&isbill="+isbill+"&isdetail="+isdetail;
	}
 //alert(url);
}

if(fieldtype == 167){   ////分权单部门



if(url.indexOf("DepartmentBrowserByDec.jsp?")>-1){
	url+="&f_weaver_belongto_userid="+userid+"&f_weaver_belongto_usertype="+usertype+"&fieldid="+fieldBodyId+"&isbill="+isbill+"&isdetail="+isdetail;
}else{
	url+="?f_weaver_belongto_userid="+userid+"&f_weaver_belongto_usertype="+usertype+"&fieldid="+fieldBodyId+"&isbill="+isbill+"&isdetail="+isdetail;
}
/*if(linkurl.indexOf("HrmDepartmentDsp.jsp?")>-1){
	linkurl+="&f_weaver_belongto_userid="+userid+"&f_weaver_belongto_usertype="+usertype;
}else{
	linkurl+="?f_weaver_belongto_userid="+userid+"&f_weaver_belongto_usertype="+usertype;
}*/
}

if(fieldtype == 168){   ////分权多部门



if(url.indexOf("MultiDepartmentBrowserByDecOrder.jsp?")>-1){
	url+="&f_weaver_belongto_userid="+userid+"&f_weaver_belongto_usertype="+usertype+"&fieldid="+fieldBodyId+"&isbill="+isbill+"&isdetail="+isdetail;
}else{
	url+="?f_weaver_belongto_userid="+userid+"&f_weaver_belongto_usertype="+usertype+"&fieldid="+fieldBodyId+"&isbill="+isbill+"&isdetail="+isdetail;
}
/*if(linkurl.indexOf("HrmDepartmentDsp.jsp?")>-1){
	linkurl+="&f_weaver_belongto_userid="+userid+"&f_weaver_belongto_usertype="+usertype;
}else{
	linkurl+="?f_weaver_belongto_userid="+userid+"&f_weaver_belongto_usertype="+usertype;
}*/
}

if(fieldtype == 169){   ////分权单分部



if(url.indexOf("SubcompanyBrowserByDec.jsp?")>-1){
	url+="&f_weaver_belongto_userid="+userid+"&f_weaver_belongto_usertype="+usertype+"&fieldid="+fieldBodyId+"&isbill="+isbill+"&isdetail="+isdetail;
}else{
	url+="?f_weaver_belongto_userid="+userid+"&f_weaver_belongto_usertype="+usertype+"&fieldid="+fieldBodyId+"&isbill="+isbill+"&isdetail="+isdetail;
}
/*if(linkurl.indexOf("HrmSubCompanyDsp.jsp?")>-1){
	linkurl+="&f_weaver_belongto_userid="+userid+"&f_weaver_belongto_usertype="+usertype;
}else{
	linkurl+="?f_weaver_belongto_userid="+userid+"&f_weaver_belongto_usertype="+usertype;
}
*/
}

if(fieldtype == 170){   ////分权多分部



if(url.indexOf("MultiSubcompanyBrowserByDec.jsp?")>-1){
	url+="&f_weaver_belongto_userid="+userid+"&f_weaver_belongto_usertype="+usertype;
}else{
	url+="?f_weaver_belongto_userid="+userid+"&f_weaver_belongto_usertype="+usertype;
}
/*if(linkurl.indexOf("HrmSubCompanyDsp.jsp?")>-1){
	linkurl+="&f_weaver_belongto_userid="+userid+"&f_weaver_belongto_usertype="+usertype;
}else{
	linkurl+="?f_weaver_belongto_userid="+userid+"&f_weaver_belongto_usertype="+usertype;
}*/
}

				if(!isreadonly){//只读时不新增此行
					if(fieldtype==9&&fieldBodyId==flowDocField){
						url="/systeminfo/BrowserMain.jsp?url=/docs/docs/DocBrowserWord.jsp";
					}
		            oRow = oTable.insertRow();
		            oCell = oRow.insertCell();
		            oCell.style.fontSize="14px";
		            oCell.style.background="#e4e4e4";
		            var ModalDialog="window.showModalDialog('";
		            if (fieldtype== 2 || fieldtype == 19){
		                ModalDialog+=url+"','','dialogHeight:320px;dialogWidth:275px')";
		            }else{
		            	if( fieldtype == 23 || fieldtype == 26 || fieldtype == 3 || fieldtype == 179){//cptbrowser
	                      	var wfid=$G("workflowid").value;
	                      	var reqid=$G("requestid").value;
	                      	var url2="";
	                      	if(url.indexOf("/cpt/capital/CapitalBrowser.jsp?")>=0){
	                      		url2=uescape("&wfid="+wfid+"&reqid="+reqid+"&"+getUserDefinedRequestParam(uservalue));
	                      	}else if(url.indexOf("/cpt/capital/CapitalBrowser.jsp")>=0){
	                      		url2=uescape("?wfid="+wfid+"&reqid="+reqid+"&"+getUserDefinedRequestParam(uservalue));
	                      	}
					        ModalDialog+=url+url2+"','','dialogHeight:600px;dialogWidth:600px')";
		            	}else if (fieldtype != 256 && fieldtype != 257 && fieldtype !=  162 && fieldtype != 171 && fieldtype != 152 && fieldtype != 142 && fieldtype != 141 && fieldtype != 135 && fieldtype !=17 && fieldtype != 18 && fieldtype!=27 && fieldtype!=37 && fieldtype!=56 && fieldtype!=57 && fieldtype!=65 && fieldtype!=165 && fieldtype!=166 && fieldtype!=167 && fieldtype!=168 && fieldtype!=194){
		                //	ModalDialog+=url+"')";
		                 	if(htmltype==3&&fieldtype==16){
		                      	var workflowid=$G("workflowid").value;
						       	var url2=uescape("&fieldid="+fieldBodyId+"&currworkflowid="+workflowid);
						         ModalDialog+=url+url2+"','','dialogHeight:600px;dialogWidth:600px')";
						    } else{
						    	//ModalDialog+=url+"?resourceCondition="+resourceids+"&isFromMode=1')";
						    	var resourceids = "";
						    	try{
			                        resourceids=$G(uservalue).value;
			                    }catch(e){}
								
			                    var _tempUrl = url;
			            		if (_tempUrl.indexOf('/systeminfo/BrowserMain.jsp?url=') >= 0) {
			            			_tempUrl = _tempUrl.substring(_tempUrl.indexOf('/systeminfo/BrowserMain.jsp?url=') + '/systeminfo/BrowserMain.jsp?url='.length);
			            		}
			                    if(_tempUrl.indexOf(".jsp?")>=0){
						        	ModalDialog+="/systeminfo/BrowserMain.jsp?url="+uescape(_tempUrl+"&selectedids=" + resourceids +"&"+getUserDefinedRequestParam(uservalue))+ "','','dialogHeight:600px;dialogWidth:600px')";
						        	//ModalDialog+=url+"&selectedids=" + resourceids + "','','dialogHeight:600px;dialogWidth:600px')";
								}else{
								    ModalDialog+="/systeminfo/BrowserMain.jsp?url="+uescape(_tempUrl+"?selectedids=" + resourceids +"&"+getUserDefinedRequestParam(uservalue))+ "','','dialogHeight:600px;dialogWidth:600px')";
								    //ModalDialog+=url+"?selectedids=" + resourceids + "','','dialogHeight:600px;dialogWidth:600px')";
								}
						    }
		                }else{
		                    var resourceids="";
		                    try{
		                        resourceids=$G(uservalue).value;
		                    }catch(e){}
		                    if (fieldtype==135){
		                    	var _tempUrl = url;
			            		if (_tempUrl.indexOf('/systeminfo/BrowserMain.jsp?url=') >= 0) {
			            			_tempUrl = _tempUrl.substring(_tempUrl.indexOf('/systeminfo/BrowserMain.jsp?url=') + '/systeminfo/BrowserMain.jsp?url='.length);
			            		}
			            		if(_tempUrl.indexOf(".jsp?")>=0){
									ModalDialog+="/systeminfo/BrowserMain.jsp?url="+uescape(_tempUrl+"&projectids=" + resourceids +"&"+getUserDefinedRequestParam(uservalue))+ "','','dialogHeight:600px;dialogWidth:600px')";
									//ModalDialog+=url+"&documentids="+resourceids+"','','dialogHeight:600px;dialogWidth:600px')";
								}else{
									ModalDialog+="/systeminfo/BrowserMain.jsp?url="+uescape(_tempUrl+"?projectids=" + resourceids +"&"+getUserDefinedRequestParam(uservalue))+ "','','dialogHeight:600px;dialogWidth:600px')";
									//ModalDialog+=url+"?documentids="+resourceids+"','','dialogHeight:600px;dialogWidth:600px')";
								}
		                    	
		                        //ModalDialog+=url+"?projectids="+resourceids+"','','dialogHeight:600px;dialogWidth:600px')";
							}
		                    else if (fieldtype==37){
		                    	var _tempUrl = url;
			            		if (_tempUrl.indexOf('/systeminfo/BrowserMain.jsp?url=') >= 0) {
			            			_tempUrl = _tempUrl.substring(_tempUrl.indexOf('/systeminfo/BrowserMain.jsp?url=') + '/systeminfo/BrowserMain.jsp?url='.length);
			            		}
		                    	
								if(_tempUrl.indexOf(".jsp?")>=0){
									ModalDialog+="/systeminfo/BrowserMain.jsp?url="+uescape(_tempUrl+"&documentids=" + resourceids +"&"+getUserDefinedRequestParam(uservalue))+ "','','dialogHeight:600px;dialogWidth:600px')";
									//ModalDialog+=url+"&documentids="+resourceids+"','','dialogHeight:600px;dialogWidth:600px')";
								}else{
									ModalDialog+="/systeminfo/BrowserMain.jsp?url="+uescape(_tempUrl+"?documentids=" + resourceids +"&"+getUserDefinedRequestParam(uservalue))+ "','','dialogHeight:600px;dialogWidth:600px')";
									//ModalDialog+=url+"?documentids="+resourceids+"','','dialogHeight:600px;dialogWidth:600px')";
								}
							}
		                    else if (fieldtype==142){
		                        ModalDialog+=url+"?receiveUnitIds="+resourceids+"','','dialogHeight:600px;dialogWidth:600px')";
							}
		                    else if (fieldtype==194){
								if(resourceids == 0) resourceids="";
		                        ModalDialog+=url+"?selectedids="+resourceids+"','','dialogHeight:600px;dialogWidth:600px')";
							}
		                    else if (fieldtype==141){
		                        //ModalDialog+=url+"?resourceCondition="+resourceids+"&isFromMode=1')";
							    tempUrl=escape("/hrm/resource/ResourceConditionBrowser.jsp?resourceCondition="+resourceids+"&isFromMode=1");
		                        ModalDialog+="/systeminfo/BrowserMain.jsp?url="+tempUrl+"','','dialogHeight:600px;dialogWidth:600px')";
							}else if (fieldtype==162){
		                        var tempUrl = url+"&beanids="+resourceids;
								tempUrl = tempUrl.substr(0,32) + escape(tempUrl.substr(32));
								ModalDialog+=""+tempUrl+"','','dialogHeight:600px;dialogWidth:600px')";
							}else if (fieldtype==256||fieldtype==257){
		                        var tempUrl = url+"&selectedids="+resourceids;
								tempUrl = tempUrl.substr(0,32) + escape(tempUrl.substr(32));
								ModalDialog+=""+tempUrl+"','','dialogHeight:600px;dialogWidth:600px')";
							}else if (fieldtype==165 || fieldtype==166 || fieldtype==167 || fieldtype==168){
		                        tindex=uservalue.indexOf("_");
		                        
		                        var _tempUrl = url;
			            		if (_tempUrl.indexOf('/systeminfo/BrowserMain.jsp?url=') >= 0) {
			            			_tempUrl = _tempUrl.substring(_tempUrl.indexOf('/systeminfo/BrowserMain.jsp?url=') + '/systeminfo/BrowserMain.jsp?url='.length);
			            		}
		                    	
								
		                        
					 

		                        if(tindex>0){
		                            tempuservalue=uservalue.substring(0,tindex);
		                            //tempUrl=escape("?isdetail=1&fieldid="+tempuservalue.substring(5));//TD15899
		                            if(_tempUrl.indexOf(".jsp?")>=0){
										ModalDialog+="/systeminfo/BrowserMain.jsp?url="+uescape(_tempUrl+"&resourceids=" + resourceids +"&isbill="+isbill+"&"+getUserDefinedRequestParam(uservalue))+ "','','dialogHeight:600px;dialogWidth:600px')";
									}else{
										ModalDialog+="/systeminfo/BrowserMain.jsp?url="+uescape(_tempUrl+"?resourceids=" + resourceids +"&isbill="+isbill+"&"+getUserDefinedRequestParam(uservalue))+ "','','dialogHeight:600px;dialogWidth:600px')";
									}
		                            
		                            /*if(url.indexOf(".jsp?")>=0){
		                            tempUrl=escape("&isdetail=1&isbill="+isbill+"&fieldid="+tempuservalue.substring(5)+"&resourceids="+resourceids);
									}else{
									tempUrl=escape("?isdetail=1&isbill="+isbill+"&fieldid="+tempuservalue.substring(5)+"&resourceids="+resourceids);
									}
		                            ModalDialog+=url+tempUrl+"','','dialogHeight:600px;dialogWidth:600px')";
		                            */
		                        }else{
		                            //ModalDialog+=url+"?fieldid="+uservalue.substring(5)+"')";//TD15899
		                        	
		                        	if(_tempUrl.indexOf(".jsp?")>=0){
										ModalDialog+="/systeminfo/BrowserMain.jsp?url="+uescape(_tempUrl+"&resourceids=" + resourceids +"&isbill="+isbill+"&"+getUserDefinedRequestParam(uservalue))+ "','','dialogHeight:600px;dialogWidth:600px')";
									}else{
										ModalDialog+="/systeminfo/BrowserMain.jsp?url="+uescape(_tempUrl+"?resourceids=" + resourceids +"&isbill="+isbill+"&"+getUserDefinedRequestParam(uservalue))+ "','','dialogHeight:600px;dialogWidth:600px')";
									}
		                        	
									/*if(url.indexOf(".jsp?")>=0){
										tempUrl=escape("&fieldid="+uservalue.substring(5)+"&isbill="+isbill+ "&resourceids="+resourceids);
									}else{
										tempUrl=escape("?fieldid="+uservalue.substring(5)+"&isbill="+isbill+ "&resourceids="+resourceids);
									}
		                            ModalDialog+=url+tempUrl+"','','dialogHeight:600px;dialogWidth:600px')";*/
		                        }
		                    }
		                    else{
		                      //  ModalDialog+=url+"?resourceids="+resourceids+"')";
		                      	 //多请求

		                     if(htmltype==3&&fieldtype==152||fieldtype==171){
		                           var workflowid=$G("workflowid").value;
							       var url2=uescape("&fieldid="+fieldBodyId+"&currworkflowid="+workflowid)
									   if(url.indexOf(".jsp?")>=0){
							       ModalDialog+=url+uescape("&resourceids="+resourceids)+url2+"','','dialogHeight:600px;dialogWidth:600px')";
								   }else{
								    ModalDialog+=url+uescape("?resourceids="+resourceids)+url2+"','','dialogHeight:600px;dialogWidth:600px')";
								   }
							    } else{
							    	
							    	var _tempUrl = url;
				            		if (_tempUrl.indexOf('/systeminfo/BrowserMain.jsp?url=') >= 0) {
				            			_tempUrl = _tempUrl.substring(_tempUrl.indexOf('/systeminfo/BrowserMain.jsp?url=') + '/systeminfo/BrowserMain.jsp?url='.length);
				            		}
			                    	
									if(_tempUrl.indexOf(".jsp?")>=0){
										ModalDialog+="/systeminfo/BrowserMain.jsp?url="+uescape(_tempUrl+"&resourceids=" + resourceids +"&"+getUserDefinedRequestParam(uservalue))+ "','','dialogHeight:600px;dialogWidth:600px')";
									}else{
										ModalDialog+="/systeminfo/BrowserMain.jsp?url="+uescape(_tempUrl+"?resourceids=" + resourceids +"&"+getUserDefinedRequestParam(uservalue))+ "','','dialogHeight:600px;dialogWidth:600px')";
									}
							    	
									//if(url.indexOf(".jsp?")>=0){
									//	ModalDialog+=url+"&resourceids="+resourceids+"','','dialogHeight:600px;dialogWidth:600px')";
									//}else{
									//	ModalDialog+=url+"?resourceids="+resourceids+"','','dialogHeight:600px;dialogWidth:600px')";
									//}
							    }
		                      }
		                }
		            }
		            //由于日期控件本身返回值为vb所以，不用转换
					if (ModalDialog.indexOf("systeminfo/Calendar_mode.jsp") == -1 && ModalDialog.indexOf("systeminfo/Clock.jsp") == -1) {        
		            	ModalDialog = "parent.string2VbArray(parent.json2String(" + ModalDialog + "))";
		            }
		            
		            reportUserIdInputName="";
					crmIdInputName="";
					if($G("reportUserIdInputName")!=null){
						reportUserIdInputName=$G("reportUserIdInputName").value;
					}
					if($G("crmIdInputName")!=null){
						crmIdInputName=$G("crmIdInputName").value;
					}
					sHtml="";    
		            var language=readCookie("languageidweaver");
		            if(language==8){
		                if(reportUserIdInputName==uservalue){
							sHtml="<img src=\"/images/BacoBrowser_wev8.gif\" style=\"cursor:pointer\" onclick=\"parent.onShowReportUserIdThis("+ModalDialog+",'"+uservalue+"',"+nowrow+","+nowcol+")\">["+SystemEnv.getHtmlNoteName(3418,language)+"]";
						}else if(crmIdInputName==uservalue){
							sHtml="<img src=\"/images/BacoBrowser_wev8.gif\" style=\"cursor:pointer\" onclick=\"parent.onShowCustomerThis('"+uservalue+"',"+nowrow+","+nowcol+")\">["+SystemEnv.getHtmlNoteName(3418,language)+"]";
						}else{
							 if(fieldtype==9&&fieldBodyId==flowDocField){
								if(newTextNodes != 1){
								  sHtml="<img src=\"/images/BacoBrowser_wev8.gif\" style=\"cursor:pointer\" onclick=\"parent.Browser("+ModalDialog+",'"+uservalue+"',"+fieldtype+","+ismand+","+nowrow+","+nowcol+")\">["+SystemEnv.getHtmlNoteName(3418,language)+"]";
						         }
							 }else{
							      sHtml="<img src=\"/images/BacoBrowser_wev8.gif\" style=\"cursor:pointer\" onclick=\"parent.Browser("+ModalDialog+",'"+uservalue+"',"+fieldtype+","+ismand+","+nowrow+","+nowcol+")\">["+SystemEnv.getHtmlNoteName(3418,language)+"]";
						     }	
						}
					    if(fieldtype==9&&fieldBodyId==flowDocField&&(cellvalue==null || cellvalue=="")){
							sHtml+="<LINK href=\"/css/Weaver_wev8.css\" type=text/css rel=STYLESHEET>";
				            sHtml+="<button id=\"createdocbutton\" style=\"cursor:pointer\" class=AddDoc onclick=\"this.disabled=true;parent.createDoc('"+fieldBodyId+"','','"+isedit+"')\" title=\""+SystemEnv.getHtmlNoteName(3419,language)+"\">"+SystemEnv.getHtmlNoteName(3419,language)+"</button>";
						}
						if(fieldtype==160){
							sHtml="<img src=\"/images/BacoBrowser_wev8.gif\" style=\"cursor:pointer\" onclick=\"parent.onShowResourceRole('"+url+"','"+uservalue+"',"+fieldtype+","+ismand+","+nowrow+","+nowcol+",'"+resourceRoleId+"')\">["+SystemEnv.getHtmlNoteName(3418,language)+"]";
						}
		                if(fieldtype==161||fieldtype==162){
		                	// update by liaodong for qc43173 in 20130911 start 
		                   var tempUrl = url;
		                   if(fieldtype == 161 || fieldtype == 162){
		                        tempUrl +="|"+uservalue+"&beanids="+resourceids;
		                   }
		                   //end
							tempUrl = tempUrl.substr(0,32) + escape(tempUrl.substr(32));
		                	sHtml="<img src=\"/images/BacoBrowser_wev8.gif\" style=\"cursor:pointer\" onclick=\"parent.showCustomizeBrowserNew('"+tempUrl+"','"+uservalue+"',"+fieldtype+","+ismand+","+nowrow+","+nowcol+")\">["+SystemEnv.getHtmlNoteName(3418,language)+"]";
		                }
					}
					else if(language==9){ 
		                 if(reportUserIdInputName==uservalue)
		                 { 
								sHtml="<img src=\"/images/BacoBrowser_wev8.gif\" style=\"cursor:pointer\" onclick=\"parent.onShowReportUserIdThis("+ModalDialog+",'"+uservalue+"',"+nowrow+" ,"+nowcol+")\">["+SystemEnv.getHtmlNoteName(3418,language)+"]"; 
						 }else if(crmIdInputName==uservalue){ 
								sHtml="<img src=\"/images/BacoBrowser_wev8.gif\" style=\"cursor:pointer\" onclick=\"parent.onShowCustomerThis('"+uservalue+"',"+nowrow+","+nowcol+" )\">["+SystemEnv.getHtmlNoteName(3418,language)+"]"; 
						 }else{ 
							if(fieldtype==9&&fieldBodyId==flowDocField){ 
								if(newTextNodes != 1){ 
									sHtml="<img src=\"/images/BacoBrowser_wev8.gif\" style=\"cursor:pointer\" onclick=\"parent.Browser("+ModalDialog+",'"+uservalue+"',"+fieldtype+" ,"+ismand+","+nowrow+","+nowcol+")\">"+SystemEnv.getHtmlNoteName(3418,language)+"]"; 
								} 
							}else{ 
								sHtml="<img src=\"/images/BacoBrowser_wev8.gif\" style=\"cursor:pointer\" onclick=\"parent.Browser("+ModalDialog+",'"+uservalue+"',"+fieldtype+" ,"+ismand+","+nowrow+","+nowcol+")\">["+SystemEnv.getHtmlNoteName(3418,language)+"]"; 
							} 
						} 
		                 if(fieldtype==9&&fieldBodyId==flowDocField&&(cellvalue==null || cellvalue=="")){ 
							sHtml+="<LINK href=\"/css/Weaver_wev8.css\" type=text/css rel=STYLESHEET>"; 
							sHtml+="<button id=\"createdocbutton\" style=\"cursor:pointer\" class=AddDoc onclick=\"this.disabled=true;parent.createDoc('"+fieldBodyId+"','','"+isedit+"')\" title=\""+SystemEnv.getHtmlNoteName(3419,language)+"\">"+SystemEnv.getHtmlNoteName(3419,language)+"</button>";
						} 
						if(fieldtype==160){ 
							sHtml="<img src=\"/images/BacoBrowser_wev8.gif\" style=\"cursor:pointer\" onclick=\"parent.onShowResourceRole('"+url+"','"+uservalue+"',"+fieldtype+","+ismand+","+nowrow+","+nowcol+",'"+resourceRoleId+"')\">["+SystemEnv.getHtmlNoteName(3418,language)+"]"; 
						} 
		                if(fieldtype==161||fieldtype==162){
		                   // update by liaodong for qc43173 in 20130911 start 
		                   var tempUrl = url;
		                   if(fieldtype == 161 || fieldtype == 162 ){
		                        tempUrl +="|"+uservalue+"&beanids="+resourceids;
		                   }
		                   //end
							tempUrl = tempUrl.substr(0,32) + escape(tempUrl.substr(32));
		                	sHtml="<img src=\"/images/BacoBrowser_wev8.gif\" style=\"cursor:pointer\" onclick=\"parent.showCustomizeBrowserNew('"+tempUrl+"','"+uservalue+"',"+fieldtype+","+ismand+","+nowrow+","+nowcol+")\">["+SystemEnv.getHtmlNoteName(3418,language)+"]";
		                }
					}
					else{
		                if(reportUserIdInputName==uservalue){
							sHtml="<img src=\"/images/BacoBrowser_wev8.gif\" style=\"cursor:pointer\" onclick=\"parent.onShowReportUserIdThis("+ModalDialog+",'"+uservalue+"',"+nowrow+","+nowcol+")\">["+SystemEnv.getHtmlNoteName(3418,language)+"]";
						}else if(crmIdInputName==uservalue){
							sHtml="<img src=\"/images/BacoBrowser_wev8.gif\" style=\"cursor:pointer\" onclick=\"parent.onShowCustomerThis('"+uservalue+"',"+nowrow+","+nowcol+")\">["+SystemEnv.getHtmlNoteName(3418,language)+"]";
						}else{
							if(fieldtype==9&&fieldBodyId==flowDocField){
								if(newTextNodes != 1){
								  sHtml="<img src=\"/images/BacoBrowser_wev8.gif\" style=\"cursor:pointer\" onclick=\"parent.Browser("+ModalDialog+",'"+uservalue+"',"+fieldtype+","+ismand+","+nowrow+","+nowcol+")\">["+SystemEnv.getHtmlNoteName(3418,language)+"]";
						        }
							}else{
							  sHtml="<img src=\"/images/BacoBrowser_wev8.gif\" style=\"cursor:pointer\" onclick=\"parent.Browser("+ModalDialog+",'"+uservalue+"',"+fieldtype+","+ismand+","+nowrow+","+nowcol+")\">["+SystemEnv.getHtmlNoteName(3418,language)+"]";
						    }
						}
		                if(fieldtype==9&&fieldBodyId==flowDocField&&(cellvalue==null || cellvalue=="")){
							sHtml+="<LINK href=\"/css/Weaver_wev8.css\" type=text/css rel=STYLESHEET>";
						   sHtml+="<button id=\"createdocbutton\" style=\"cursor:pointer\" class=AddDoc onclick=\"this.disabled=true;parent.createDoc('"+fieldBodyId+"','','"+isedit+"')\" title=\""+SystemEnv.getHtmlNoteName(3419,language)+"\">"+SystemEnv.getHtmlNoteName(3419,language)+"</button>";
						}
						if(fieldtype==160){
							sHtml="<img src=\"/images/BacoBrowser_wev8.gif\" style=\"cursor:pointer\" onclick=\"parent.onShowResourceRole('"+url+"','"+uservalue+"',"+fieldtype+","+ismand+","+nowrow+","+nowcol+",'"+resourceRoleId+"')\">["+SystemEnv.getHtmlNoteName(3418,language)+"]";
						}
		                if(fieldtype==161||fieldtype==162){
		                	// update by liaodong for qc43173 in 20130911 start 
		                   var tempUrl = url;
		                   if(fieldtype == 161 || fieldtype == 162 ){
		                        tempUrl +="|"+uservalue+"&beanids="+resourceids;
		                   }
		                   //end
							tempUrl = tempUrl.substr(0,32) + escape(tempUrl.substr(32));
							//alert(tempUrl+","+uservalue+","+fieldtype+","+ismand+","+nowrow+","+nowcol);
		                	sHtml="<img src=\"/images/BacoBrowser_wev8.gif\" style=\"cursor:pointer\" onclick=\"parent.showCustomizeBrowserNew('"+tempUrl+"','"+uservalue+"',"+fieldtype+","+ismand+","+nowrow+","+nowcol+")\">["+SystemEnv.getHtmlNoteName(3418,language)+"]";
		                }
					}
					
		            oDiv = document.createElement("div");
		            oDiv.innerHTML = sHtml;
		            oCell.appendChild(oDiv);
					oCell = oRow.insertCell();
		            oCell.style.color="blue";
		            oCell.style.fontSize="14px";
		            oCell.style.background="#e4e4e4";
					sHtml="";
		            if(language==8){
		                if(fieldtype==9&&fieldBodyId==flowDocField){
							if(newTextNodes != 1){
							  sHtml="<a href='#' onclick=\"parent.clearobj('"+uservalue+"',"+nowrow+","+nowcol+")\">"+SystemEnv.getHtmlNoteName(3475,language)+"</a>";
							}
						}else{
		                      sHtml="<a href='#' onclick=\"parent.clearobj('"+uservalue+"',"+nowrow+","+nowcol+")\">"+SystemEnv.getHtmlNoteName(3475,language)+"</a>";
						}   
					}
					else if(language==9){
		                if(fieldtype==9&&fieldBodyId==flowDocField){
							if(newTextNodes != 1){
							  sHtml="<a href='#' onclick=\"parent.clearobj('"+uservalue+"',"+nowrow+","+nowcol+")\">"+SystemEnv.getHtmlNoteName(3475,language)+"</a>";
							}
						}else{
		                      sHtml="<a href='#' onclick=\"parent.clearobj('"+uservalue+"',"+nowrow+","+nowcol+")\">"+SystemEnv.getHtmlNoteName(3475,language)+"</a>";
						}
					}
					else{
		                if(fieldtype==9&&fieldBodyId==flowDocField){
							if(newTextNodes != 1){
							  sHtml="<a href='#' onclick=\"parent.clearobj('"+uservalue+"',"+nowrow+","+nowcol+")\">"+SystemEnv.getHtmlNoteName(3475,language)+"</a>";
							}
						}else{
		                      sHtml="<a href='#' onclick=\"parent.clearobj('"+uservalue+"',"+nowrow+","+nowcol+")\">"+SystemEnv.getHtmlNoteName(3475,language)+"</a>";
						}
					}
		            oDiv = document.createElement("div");
		            oDiv.innerHTML = sHtml;
		            oCell.appendChild(oDiv);
            		indexrow++;
				}
            
            if(fieldtype==87){
                oRow = oTable.insertRow();
                oCell = oRow.insertCell();
                oCell.style.fontSize="14px";
                oCell.style.background="#e4e4e4";
                oDiv = document.createElement("div");
                oDiv.innerHTML = "<A href='#' onclick=\"parent.window.open('/meeting/report/MeetingRoomPlan.jsp')\">"+SystemEnv.getHtmlNoteName(3476,readCookie("languageidweaver"))+"</A>";
				
                oCell.appendChild(oDiv);
                oCell = oRow.insertCell();
                oCell.style.fontSize="14px";
                oCell.style.background="#e4e4e4";
                oDiv = document.createElement("div");
                oDiv.innerHTML = "";
                oCell.appendChild(oDiv);
            
                indexrow++;
            }


			}
			if(isreadonly){//判断是否存在超链接



				var len=jQuery(oTable).find("a").length;
				if(len==0){
					for(i=(indexrow-1);i>=0;i--){
	                    oTable.deleteRow(i);
	                }
	                $G("indexrow").value=0;
					return ;
				}
			}
            $G("indexrow").value=indexrow;
            var ocont=$G("ocontext");
            ocont.style.display='';
            oPopup.document.body.attachEvent("onmouseout",mouseout);
            oPopup.document.body.innerHTML = ocont.innerHTML;             
            if(fieldtype==161||fieldtype==162){            	
            	if(selectshow!=0 && ismand>0) oPopup.show(lefter,topper,200,ocont.offsetHeight, document.ChinaExcel);            		
            }else{
            	if(!(cellvalue==null || cellvalue=="") || (selectshow!=0 && ismand>0)) oPopup.show(lefter,topper,200,ocont.offsetHeight, document.ChinaExcel);	
            }
            ocont.style.display='none';
        }else if(htmltype=="7"&&fieldtype=="1"){//特殊字段，自定义链接
            var urlid="";
            var url="";
            var urllink="";
            var urllinkno="";
            var i;
            var selvalue=new Array();
            var urlarr=new Array();
            var urlno=new Array();
            var oTable=$G("otable");
            var oDiv;
            var sHtml = "";
            var indexrow=parseInt($G("indexrow").value);
            if(indexrow>0){
                for(i=(indexrow-1);i>=0;i--){
                    oTable.deleteRow(i);
                }
                indexrow=0;
            }
            try{
                urlid=$G(uservalue).value;
                var fieldstr=uservalue;
                if(uservalue.indexOf("_")>0){
                    fieldstr=uservalue.substring(0,uservalue.indexOf("_"));
                }
                url=$G(fieldstr+"_url").value;
                urllink=$G(fieldstr+"_urllink").value;
                urllinkno=$G(uservalue+"_linkno").value;
            }catch(e){}
            if(cellvalue!=null && cellvalue!=""){
                if(cellvalue.indexOf(",")>-1){
                    selvalue=cellvalue.split(",");
                    urlarr=urlid.split(",");
                    urlno=urllinkno.split(",");
                }else{
                    selvalue[0]=cellvalue;
                    urlarr[0]=urlid;
                    urlno[0]=urllinkno;
                }
				oTable.border=1;
                oRow = oTable.insertRow();
                oCell = oRow.insertCell();
                oCell.colSpan =2;
                oCell.style.fontSize="14px";
                oCell.style.color="blue";
                for(i=0;i<selvalue.length;i++){
                    if(sHtml.length>0){
                        sHtml+=" ";
                    }
                    if(urllink!=""){
                            sHtml+="<a href='#' onclick=\"parent.openWindowNoRequestid('"+urllink+"')\">"+selvalue[i]+"</a>";
                    }else{
                        sHtml+=selvalue[i];
                    }
                }
                oDiv = document.createElement("div");
                oDiv.innerHTML = sHtml;
                oCell.appendChild(oDiv);
                indexrow++;
            }
            $G("indexrow").value=indexrow;
            var ocont=$G("ocontext");
            ocont.style.display='';
            oPopup.document.body.attachEvent("onmouseout",mouseout);
            oPopup.document.body.innerHTML = ocont.innerHTML; 
            oPopup.show(lefter,topper,200,ocont.offsetHeight, document.ChinaExcel);	
            ocont.style.display='none';
        }else{
            inprepDspDateInputName="";
			if($G("inprepDspDateInputName")!=null){
				inprepDspDateInputName=$G("inprepDspDateInputName").value;
			}
			if(inprepDspDateInputName==uservalue&&selectshow!=0 && ismand>0){
				if(isreadonly)return;
				showPopupForInprepDspDate(uservalue,cellvalue,ismand,selectshow);
			}else{
				//hidePopup();
			}        
        }
    }
}

function showPopupCreateCodeAgain(uservalue,cellvalue,ismand,selectshow){

	var isShowPopupCreateCodeAgain=-1;
	if($G("isShowPopupCreateCodeAgain")!=null){
		isShowPopupCreateCodeAgain=$G("isShowPopupCreateCodeAgain").value;
	}
	if(isShowPopupCreateCodeAgain!=1){
		return ;
	}

	getwidth();
    getHeight();
    if(!frmmain.ChinaExcel.ShowHeader){
		showwidth=showwidth;
    }else{
		showwidth=showwidth-20;
    }
    lefter =showwidth;
    topper =frmmain.ChinaExcel.GetMousePosY();

            var oTable=$G("otable");
            var oDiv;
            var sHtml = "";
            var indexrow=parseInt($G("indexrow").value);

            if(indexrow>0){
                for(i=(indexrow-1);i>=0;i--){
                    oTable.deleteRow(i);
                }
                indexrow=0;
            }
            oRow = oTable.insertRow();
            oCell = oRow.insertCell();
            oCell.style.fontSize="14px";
            oCell.style.background="#e4e4e4";

			sHtml="";    
            var language=readCookie("languageidweaver");
            if(language==8){
				sHtml+="<button id=\"createCodeAgain\" style=\"cursor:pointer\" class=AddDoc onclick=\"this.disabled=true;parent.onCreateCodeAgain()\" title=\""+SystemEnv.getHtmlNoteName(3477,language)+"\">"+SystemEnv.getHtmlNoteName(3477,language)+"</button><button id=\"onChooseReservedCode\" style=\"cursor:pointer\" class=AddDoc onclick=\"this.disabled=true;parent.onChooseReservedCode()\" title=\""+SystemEnv.getHtmlNoteName(3478,language)+"\">"+SystemEnv.getHtmlNoteName(3478,language)+"</button><button id=\"onNewReservedCode\" style=\"cursor:pointer\" class=AddDoc onclick=\"this.disabled=true;parent.onNewReservedCode()\" title=\""+SystemEnv.getHtmlNoteName(3479,language)+"\">"+SystemEnv.getHtmlNoteName(3479,language)+"</button>";
			}else if(language==9){
				sHtml+="<button id=\"createCodeAgain\" style=\"cursor:pointer\" class=AddDoc onclick=\"this.disabled=true;parent.onCreateCodeAgain()\" title=\""+SystemEnv.getHtmlNoteName(3477,language)+"\">"+SystemEnv.getHtmlNoteName(3477,language)+"</button><button id=\"onChooseReservedCode\" style=\"cursor:pointer\" class=AddDoc onclick=\"this.disabled=true;parent.onChooseReservedCode()\" title=\""+SystemEnv.getHtmlNoteName(3478,language)+"\">"+SystemEnv.getHtmlNoteName(3478,language)+"</button><button id=\"onNewReservedCode\" style=\"cursor:pointer\" class=AddDoc onclick=\"this.disabled=true;parent.onNewReservedCode()\" title=\""+SystemEnv.getHtmlNoteName(3479,language)+"\">"+SystemEnv.getHtmlNoteName(3479,language)+"</button>";
			}else{
				sHtml+="<button id=\"createCodeAgain\" style=\"cursor:pointer\" class=AddDoc onclick=\"this.disabled=true;parent.onCreateCodeAgain()\" title=\""+SystemEnv.getHtmlNoteName(3477,language)+"\">"+SystemEnv.getHtmlNoteName(3477,language)+"</button><button id=\"onChooseReservedCode\" style=\"cursor:pointer\" class=AddDoc onclick=\"this.disabled=true;parent.onChooseReservedCode()\" title=\""+SystemEnv.getHtmlNoteName(3478,language)+"\">"+SystemEnv.getHtmlNoteName(3478,language)+"</button><button id=\"onNewReservedCode\" style=\"cursor:pointer\" class=AddDoc onclick=\"this.disabled=true;parent.onNewReservedCode()\" title=\""+SystemEnv.getHtmlNoteName(3479,language)+"\">"+SystemEnv.getHtmlNoteName(3479,language)+"</button>";
			}

            oDiv = document.createElement("div");
            oDiv.innerHTML = sHtml;
            oCell.appendChild(oDiv);
            
            indexrow++;

            $G("indexrow").value=indexrow;
            var ocont=$G("ocontext");
            ocont.style.display='';
            oPopup.document.body.attachEvent("onmouseout",mouseout);
            oPopup.document.body.innerHTML = ocont.innerHTML;             
            oPopup.show(lefter,topper,400,ocont.offsetHeight, document.ChinaExcel);	
            ocont.style.display='none';
}

function showPopupForInprepDspDate(uservalue,cellvalue,ismand,selectshow){

            var oTable=$G("otable");
            var oDiv;
            var sHtml = "";
            var indexrow=parseInt($G("indexrow").value);
            if(indexrow>0){
                for(i=(indexrow-1);i>=0;i--){
                    oTable.deleteRow(i);
                }
                indexrow=0;
            }

			oTable.border=1;
			oRow = oTable.insertRow();
			oCell = oRow.insertCell();
			oCell.colSpan =2;
			oCell.style.fontSize="14px";
			oCell.style.color="blue";

			var inprepfrequenceTemp=$G("inprepfrequenceTemp").value;

			var yearTemp=$G("year").value;
			var monthTemp=$G("month").value;
			var dayTemp=$G("day").value;
			var currentYearTemp=$G("currentYearTemp").value;

			var language=readCookie("languageidweaver");

            var label_445=SystemEnv.getHtmlNoteName(3480,language);
            var label_6076=SystemEnv.getHtmlNoteName(3481,language);


			if(inprepfrequenceTemp==1||inprepfrequenceTemp==2||inprepfrequenceTemp==3||inprepfrequenceTemp==6||inprepfrequenceTemp==7){
				sHtml+=label_445+"：<select name=\"yearTemp\" onChange=\"parent.onChangeTempOnPopup('yearTemp',this.value)\">";
                for(iTemp=2 ; iTemp>-3;iTemp--) {
					tempyear = currentYearTemp - iTemp ;
					selected = "" ;
					if( yearTemp==tempyear){
						selected = "selected" ;
					}
					sHtml+="<option value=\""+tempyear+"\" "+selected+">"+tempyear+"</option>";
                }
				sHtml+="</select>";
			}

			if(inprepfrequenceTemp==2||inprepfrequenceTemp==3) {
				sHtml+=label_6076+"：<select name=\"monthTemp\" onChange=\"parent.onChangeTempOnPopup('monthTemp',this.value)\">";
				if(monthTemp=="01"){
					sHtml+="<option value=\"01\" selected>1</option>";
				}else{
					sHtml+="<option value=\"01\">1</option>";
				}
				if(monthTemp=="02"){
					sHtml+="<option value=\"02\" selected>2</option>";
				}else{
					sHtml+="<option value=\"02\">2</option>";
				}
				if(monthTemp=="03"){
					sHtml+="<option value=\"03\" selected>3</option>";
				}else{
					sHtml+="<option value=\"03\">3</option>";
				}
				if(monthTemp=="04"){
					sHtml+="<option value=\"04\" selected>4</option>";
				}else{
					sHtml+="<option value=\"04\">4</option>";
				}
				if(monthTemp=="05"){
					sHtml+="<option value=\"05\" selected>5</option>";
				}else{
					sHtml+="<option value=\"05\">5</option>";
				}
				if(monthTemp=="06"){
					sHtml+="<option value=\"06\" selected>6</option>";
				}else{
					sHtml+="<option value=\"06\">6</option>";
				}
				if(monthTemp=="07"){
					sHtml+="<option value=\"07\" selected>7</option>";
				}else{
					sHtml+="<option value=\"07\">7</option>";
				}
				if(monthTemp=="08"){
					sHtml+="<option value=\"08\" selected>8</option>";
				}else{
					sHtml+="<option value=\"08\">8</option>";
				}
				if(monthTemp=="09"){
					sHtml+="<option value=\"09\" selected>9</option>";
				}else{
					sHtml+="<option value=\"09\">9</option>";
				}
				if(monthTemp=="10"){
					sHtml+="<option value=\"10\" selected>10</option>";
				}else{
					sHtml+="<option value=\"10\">10</option>";
				}
				if(monthTemp=="11"){
					sHtml+="<option value=\"11\" selected>11</option>";
				}else{
					sHtml+="<option value=\"11\">11</option>";
				}
				if(monthTemp=="12"){
					sHtml+="<option value=\"12\" selected>12</option>";
				}else{
					sHtml+="<option value=\"12\">12</option>";
				}
				sHtml+="</select>";
			}

			if(inprepfrequenceTemp==3) {
				sHtml+=SystemEnv.getHtmlNoteName(3485,language)+"<select name=\"dayTemp\" onChange=\"parent.onChangeTempOnPopup('dayTemp',this.value)\">";
				if(dayTemp<10){
					sHtml+="<option value=\"05\" selected>"+SystemEnv.getHtmlNoteName(3482,language)+"</option>";
				}else{
					sHtml+="<option value=\"05\">"+SystemEnv.getHtmlNoteName(3482,language)+"</option>";
				}
				if(dayTemp>=10&&dayTemp<20){
					sHtml+="<option value=\"15\" selected>"+SystemEnv.getHtmlNoteName(3483,language)+"</option>";
				}else{
					sHtml+="<option value=\"15\">"+SystemEnv.getHtmlNoteName(3483,language)+"</option>";
				}
				if(dayTemp>=20){
					sHtml+="<option value=\"25\" selected>"+SystemEnv.getHtmlNoteName(3484,language)+"</option>";
				}else{
					sHtml+="<option value=\"25\">"+SystemEnv.getHtmlNoteName(3484,language)+"</option>";
				}
				sHtml+="</select>";
			}

			if(inprepfrequenceTemp==6) {
				sHtml+=SystemEnv.getHtmlNoteName(3486,language)+"<select name=\"monthTemp\"  onChange=\"parent.onChangeTempOnPopup('monthTemp',this.value)\">";
				if(monthTemp<7){
					sHtml+="<option value=\"01\" selected>"+SystemEnv.getHtmlNoteName(3487,language)+"</option>";
				}else{
					sHtml+="<option value=\"01\">"+SystemEnv.getHtmlNoteName(3487,language)+"</option>";
				}
				if(monthTemp>=7){
					sHtml+="<option value=\"07\" selected>"+SystemEnv.getHtmlNoteName(3488,language)+"</option>";
				}else{
					sHtml+="<option value=\"07\">"+SystemEnv.getHtmlNoteName(3488,language)+"</option>";
				}
				sHtml+="</select>";
			}

			if(inprepfrequenceTemp==7) {
				sHtml+=SystemEnv.getHtmlNoteName(3489,language)+"<select name=\"monthTemp\"  onChange=\"parent.onChangeTempOnPopup('monthTemp',this.value)\">";
				if(monthTemp<4){
					sHtml+="<option value=\"01\" selected>"+SystemEnv.getHtmlNoteName(3490,language)+"</option>";
				}else{
					sHtml+="<option value=\"01\">"+SystemEnv.getHtmlNoteName(3490,language)+"</option>";
				}
				if(monthTemp>=4&&monthTemp<7){
					sHtml+="<option value=\"04\" selected>"+SystemEnv.getHtmlNoteName(3491,language)+"</option>";
				}else{
					sHtml+="<option value=\"04\">"+SystemEnv.getHtmlNoteName(3491,language)+"</option>";
				}
				if(monthTemp>=7&&monthTemp<10){
					sHtml+="<option value=\"07\" selected>"+SystemEnv.getHtmlNoteName(3492,language)+"</option>";
				}else{
					sHtml+="<option value=\"07\">"+SystemEnv.getHtmlNoteName(3492,language)+"</option>";
				}
				if(monthTemp>=10){
					sHtml+="<option value=\"10\" selected>"+SystemEnv.getHtmlNoteName(3493,language)+"</option>";
				}else{
					sHtml+="<option value=\"10\">"+SystemEnv.getHtmlNoteName(3493,language)+"</option>";
				}
				sHtml+="</select>";
			}

			if(inprepfrequenceTemp==0||inprepfrequenceTemp==4||inprepfrequenceTemp==5) {
				var ModalDialog="window.showModalDialog('/systeminfo/Calendar_mode.jsp','','dialogHeight:320px;dialogWidth:275px')";
                if(language==8){
					sHtml="<img src=\"/images/BacoBrowser_wev8.gif\" style=\"cursor:pointer\" onclick=\"parent.onShowInprepDspDateThis("+ModalDialog+",'"+uservalue+"',2,"+ismand+","+nowrow+","+nowcol+")\">[Please Select]";
			    }
			    else if(language==9){
					sHtml="<img src=\"/images/BacoBrowser_wev8.gif\" style=\"cursor:pointer\" onclick=\"parent.onShowInprepDspDateThis("+ModalDialog+",'"+uservalue+"',2,"+ismand+","+nowrow+","+nowcol+")\">[請選擇]";
			    }
			    else{
					sHtml="<img src=\"/images/BacoBrowser_wev8.gif\" style=\"cursor:pointer\" onclick=\"parent.onShowInprepDspDateThis("+ModalDialog+",'"+uservalue+"',2,"+ismand+","+nowrow+","+nowcol+")\">[请选择]";
			    }
			}

			oDiv = document.createElement("div");
			oDiv.innerHTML = sHtml;
			oCell.appendChild(oDiv);
			indexrow++;


			if(selectshow!=0 && ismand>0&&inprepfrequenceTemp!=0&&inprepfrequenceTemp!=4&&inprepfrequenceTemp!=5){
				oRow = oTable.insertRow();
				oCell = oRow.insertCell();
				oCell.style.fontSize="14px";
				oCell.style.background="#e4e4e4";


				if(language==8){
				    sHtml="<a href='#' onclick=\"parent.onChangeInprepDspDate('"+uservalue+"',"+nowrow+","+nowcol+")\">"+SystemEnv.getHtmlNoteName(3451,language)+"</a>";
				}
				else if(language==9){
				    sHtml="<a href='#' onclick=\"parent.onChangeInprepDspDate('"+uservalue+"',"+nowrow+","+nowcol+")\">"+SystemEnv.getHtmlNoteName(3451,language)+"</a>";
				}
				else{
				    sHtml="<a href='#' onclick=\"parent.onChangeInprepDspDate('"+uservalue+"',"+nowrow+","+nowcol+")\">"+SystemEnv.getHtmlNoteName(3451,language)+"</a>";
				}
				oDiv = document.createElement("div");
				oDiv.innerHTML = sHtml;
				oCell.appendChild(oDiv);

				oCell = oRow.insertCell();
				oCell.style.color="blue";
				oCell.style.fontSize="14px";
				oCell.style.background="#e4e4e4";
				if(language==8){
				    sHtml="<a href='#' onclick=\"parent.clearobj('"+uservalue+"',"+nowrow+","+nowcol+")\">"+SystemEnv.getHtmlNoteName(3475,language)+"</a>";
				}
				else if(language==9){
				    sHtml="<a href='#' onclick=\"parent.clearobj('"+uservalue+"',"+nowrow+","+nowcol+")\">"+SystemEnv.getHtmlNoteName(3475,language)+"</a>";
				}
				else{
				    sHtml="<a href='#' onclick=\"parent.clearobj('"+uservalue+"',"+nowrow+","+nowcol+")\">"+SystemEnv.getHtmlNoteName(3475,language)+"</a>";
				}
				oDiv = document.createElement("div");
				oDiv.innerHTML = sHtml;
				oCell.appendChild(oDiv);
				indexrow++;
			}
			if(inprepfrequenceTemp==1||inprepfrequenceTemp==2||inprepfrequenceTemp==3||inprepfrequenceTemp==6||inprepfrequenceTemp==7){
				oRow = oTable.insertRow();
				oRow.style.height=200;
				oCell = oRow.insertCell();
				oCell.style.fontSize="14px";
				oCell.style.background="#e4e4e4";
				indexrow++;
			}
            $G("indexrow").value=indexrow;
            var ocont=$G("ocontext");
            ocont.style.display='';

            if(inprepfrequenceTemp==0||inprepfrequenceTemp==4||inprepfrequenceTemp==5){
				oPopup.document.body.attachEvent("onmouseout",mouseout);
				oPopup.document.body.innerHTML = ocont.innerHTML;
				oPopup.show(lefter,topper,250,ocont.offsetHeight, document.ChinaExcel);
			}else{
				oPopupInprepDspDate.document.body.innerHTML = ocont.innerHTML;
				oPopupInprepDspDate.show(lefter,topper,250,ocont.offsetHeight, document.ChinaExcel);
			}
            ocont.style.display='none';
}

function onChangeInprepDspDate(uservalue,nowrow,nowcol){

	var yearTemp="";
	var monthTemp="";
	var dayTemp="";
	var inprepDspDate="";

	if($G("yearTemp")!=null){
		yearTemp=$G("yearTemp").value;
		$G("year").value=yearTemp;
	}
	if($G("monthTemp")!=null){
		monthTemp=$G("monthTemp").value;
		$G("month").value=monthTemp;
	}
	if($G("dayTemp")!=null){
		dayTemp=$G("dayTemp").value;
		$G("day").value=dayTemp;
	}
	var language=readCookie("languageidweaver");
	var inprepfrequenceTemp=$G("inprepfrequenceTemp").value;
    if(inprepfrequenceTemp==1){
		inprepDspDate=yearTemp;
	}else if(inprepfrequenceTemp==2){
		inprepDspDate=yearTemp + "-"+monthTemp;
	}else if(inprepfrequenceTemp==3){
		inprepDspDate=yearTemp + "-"+monthTemp;
		if(dayTemp=="05"){
			inprepDspDate += " "+SystemEnv.getHtmlNoteName(3482,language) ;
		}else if(dayTemp=="15"){
			inprepDspDate += " "+SystemEnv.getHtmlNoteName(3483,language) ;
		}else if(dayTemp=="25"){
			inprepDspDate += " "+SystemEnv.getHtmlNoteName(3484,language) ;
		}
	}else if(inprepfrequenceTemp==6){
		inprepDspDate=yearTemp;
		if(monthTemp=="01"){
			inprepDspDate += " "+SystemEnv.getHtmlNoteName(3487,language) ;
		}else if(monthTemp=="07"){
			inprepDspDate +=" "+SystemEnv.getHtmlNoteName(3488,language) ;
		}
	}else if(inprepfrequenceTemp==7){
		inprepDspDate=yearTemp;
		if(monthTemp=="01"){
			inprepDspDate += " "+SystemEnv.getHtmlNoteName(3490,language) ;
		}else if(monthTemp=="04"){
			inprepDspDate += " "+SystemEnv.getHtmlNoteName(3491,language) ;
		}else if(monthTemp=="07"){
			inprepDspDate += " "+SystemEnv.getHtmlNoteName(3492,language) ;
		}else if(monthTemp=="10"){
			inprepDspDate += " "+SystemEnv.getHtmlNoteName(3493,language) ;
		}
	}

	frmmain.ChinaExcel.SetCellVal(nowrow,nowcol,inprepDspDate)
	$G(uservalue).value=inprepDspDate
	imgshoworhide(nowrow,nowcol)
	frmmain.ChinaExcel.RefreshViewSize();
    hidePopup();
}

function onChangeTempOnPopup(objName,objValue){
	$G(objName).value=objValue;
}

function clearobj(uservalue,nowrow,nowcol){
    hidePopup();
    try{
        $G(uservalue).value="";
        DataInputByBrowser(uservalue);
    }catch(e){}
    frmmain.ChinaExcel.SetCellVal(nowrow,nowcol,"");
    onShowFnaInfo(uservalue,nowrow);
    imgshoworhide(nowrow,nowcol);
    frmmain.ChinaExcel.RefreshViewSize();
}
function hidePopup()
{
    oPopup.hide();
    oPopupInprepDspDate.hide();
}
function DataInputByBrowser(fieldid){
    var fieldstr = fieldid;
    if (fieldid.indexOf("_") > 0) {
        fieldstr = fieldid.substring(0, fieldid.indexOf("_"));
    }
    if (trrigerfieldary != "" && trrigerfieldary.join("qwertyuiop").indexOf(fieldstr) != -1) {
        datainput(fieldid);
    } else if (trrigerdetailfieldary != "" && trrigerdetailfieldary.join("qwertyuiop").indexOf(fieldstr) != -1) {
        datainputd(fieldid);
    }
}




function imgshoworhide(nowrow,nowcol){
    var showtype=frmmain.ChinaExcel.GetCellUserValue(nowrow,nowcol);
    var cellvalue=frmmain.ChinaExcel.GetCellValue(nowrow,nowcol);
    var uservalue=frmmain.ChinaExcel.GetCellUserStringValue(nowrow,nowcol);
    if(uservalue!=null && uservalue!="" && uservalue.indexOf("_add")<0 && uservalue.indexOf("_del")<0 && uservalue.indexOf("_head")<0 && uservalue.indexOf("_end")<0 && uservalue.indexOf("_sel")<0&& uservalue.indexOf("_showKeyword")<0){
        if(uservalue=="requestname"){
          if(cellvalue!=null && cellvalue!=""){
          	frmmain.ChinaExcel.DeleteCellImage(nowrow,nowcol,nowrow,nowcol);
          	if(showtype==0) frmmain.ChinaExcel.SetCellProtect(nowrow,nowcol,nowrow,nowcol,true);
          }else{
          	frmmain.ChinaExcel.ReadHttpImageFile("/images/BacoError_wev8.gif",nowrow,nowcol,true,true);
          }
        }else if(uservalue=="qianzi"){
          if(cellvalue!=null && cellvalue!=""){
          	frmmain.ChinaExcel.DeleteCellImage(nowrow,nowcol,nowrow,nowcol);
          }else{
			  
			  var isSignMustInput=0;
			  if($G("isSignMustInput")!=null){
				  isSignMustInput=$G("isSignMustInput").value;
			  }

			  if(isSignMustInput==1){
				  frmmain.ChinaExcel.ReadHttpImageFile("/images/BacoError_wev8.gif",nowrow,nowcol,true,true);
			  }
          }
        }else{
	        var index=uservalue.lastIndexOf("_");
	        var htmltype=0;
	        if(index>0){
	            htmltype=uservalue.substr(index+1);
				uservalue=uservalue.substring(0,index);
	        }
	        var isProtect=frmmain.ChinaExcel.IsCellProtect(nowrow,nowcol);
	        if(isProtect){
	           frmmain.ChinaExcel.SetCellProtect(nowrow,nowcol,nowrow,nowcol,false);
	        }
			if(htmltype == 3) {//added by wcd 2015-08-24
				index=uservalue.lastIndexOf("_");
				if(index>0 && uservalue.substr(index+1) == 34) {
					htmltype = 5;
					frmmain.ChinaExcel.DeleteCellImage(nowrow,nowcol,nowrow,nowcol);
				}
			}
	        if(showtype==2){
	            if(cellvalue!=null && cellvalue!=""){
	                frmmain.ChinaExcel.DeleteCellImage(nowrow,nowcol,nowrow,nowcol);
	            }else{
	                if(htmltype==3 || htmltype==6){
	                    frmmain.ChinaExcel.ReadHttpImageFile("/images/BacoBrowser_b_wev8.gif",nowrow,nowcol,true,true);
	                }else{
	                    frmmain.ChinaExcel.ReadHttpImageFile("/images/BacoError_wev8.gif",nowrow,nowcol,true,true);
	                }
	            }
	        }else if(showtype==1 && (htmltype==3 || htmltype==6)){
	            if(cellvalue!=null && cellvalue!=""){
	                frmmain.ChinaExcel.DeleteCellImage(nowrow,nowcol,nowrow,nowcol);
	            }else{
	                frmmain.ChinaExcel.ReadHttpImageFile("/images/BacoBrowser_wev8.gif",nowrow,nowcol,true,true);
	            }
	        }
	        if(isProtect){
	           frmmain.ChinaExcel.SetCellProtect(nowrow,nowcol,nowrow,nowcol,true);
	        }
	      }
    }
}

function imghide(nowrow,nowcol){
    var isprotect=frmmain.ChinaExcel.IsCellProtect(nowrow,nowcol);
    if(isprotect) frmmain.ChinaExcel.SetCellProtect(nowrow,nowcol,nowrow,nowcol,false);
    frmmain.ChinaExcel.DeleteCellImage(nowrow,nowcol,nowrow,nowcol);
    if(isprotect) frmmain.ChinaExcel.SetCellProtect(nowrow,nowcol,nowrow,nowcol,true);
}

function ToExcel(){
    var maxcol=frmmain.ChinaExcel.GetMaxCol();
    var isformprotect=frmmain.ChinaExcel.FormProtect;
	if(isformprotect) frmmain.ChinaExcel.FormProtect=false;
    for(i=0;i<rowgroup.length;i++){
        var headrow=frmmain.ChinaExcel.GetCellUserStringValueRow("detail"+i+"_head");
        if(headrow>0){
            var nowrow=headrow+1;
            while(frmmain.ChinaExcel.IsRowHide(nowrow)){
                for(k=0;k<=maxcol;k++){
                    imghide(nowrow,k);
                }
                nowrow++;
            }
        }
    }
	var maxrow = frmmain.ChinaExcel.GetMaxRow();
	// update double √ error by gzt 2014-03-05
	for(var ax=0; ax<=maxrow; ax++){
		for(var bx=0; bx<=maxcol; bx++){
			try{
				//If GetCellType is 2 is check box
				if(frmmain.ChinaExcel.GetCellType(ax, bx)==2){
					var isprotect=frmmain.ChinaExcel.IsCellProtect(ax, bx);
					if(isprotect) frmmain.ChinaExcel.SetCellProtect(ax, bx,ax, bx,false);
					frmmain.ChinaExcel.DeleteCellImage(ax, bx,ax, bx);
					if(isprotect) frmmain.ChinaExcel.SetCellProtect(ax, bx,ax, bx,true);
				}
			}catch(e){}
		}
	
	}
	//如果单元格内容以0开始，则将单元格设为“文本”格式
	for(var ax=0; ax<=maxrow; ax++){
		for(var bx=0; bx<=maxcol; bx++){
			try{
				if(frmmain.ChinaExcel.GetCellContentType(ax, bx) == 1){
					var intValue0 = frmmain.ChinaExcel.GetCellValue(ax, bx);
					if(intValue0.trim().indexOf("0") == 0){
						var isprotect=frmmain.ChinaExcel.IsCellProtect(ax, bx);
						if(isprotect) frmmain.ChinaExcel.SetCellProtect(ax, bx,ax, bx,false);
						frmmain.ChinaExcel.SetCellDigitShowStyle(ax, bx,ax, bx,8,0);
						if(isprotect) frmmain.ChinaExcel.SetCellProtect(ax, bx,ax, bx,true);
					}
				}
			}catch(e){}
		}	
	}
	frmmain.ChinaExcel.OnSaveAsExcelFile();
	
    if(isformprotect) frmmain.ChinaExcel.FormProtect=true;
}

function changevalue(uservalue,cellvalue,ismand){
		if(uservalue=="requestname"){
    		cellvalue=cellvalue.replace(/\r/g,"<br>");
    		cellvalue=cellvalue.replace(/\n/g,"");
    		$G(uservalue).value=cellvalue;
   	}else if(uservalue=="qianzi"){
    		cellvalue=cellvalue.replace(/\r/g,"<br>");
    		cellvalue=cellvalue.replace(/\n/g,"");
    		$G("remark").value=cellvalue;
   	}
   	else
    if(uservalue!=null && uservalue!="" && uservalue.lastIndexOf("_")>-1 && ismand>0){
        var htmltype=uservalue.substring(uservalue.lastIndexOf("_")+1);
        uservalue=uservalue.substring(0,uservalue.lastIndexOf("_"));
        var fieldtype=0;
        if(uservalue.lastIndexOf("_")>-1){
            fieldtype=uservalue.substring(uservalue.lastIndexOf("_")+1);
            uservalue=uservalue.substring(0,uservalue.lastIndexOf("_"));
        }
        //取消重新计算，解决滚动条会自动滚动到最前端问题
//        if(htmltype==1 && (fieldtype==2 || fieldtype==3)){
//			frmmain.ChinaExcel.ReCalculate();
//		}

        if(htmltype!="3" && htmltype!="5" && htmltype!="6" && ismand>0){
            cellvalue=cellvalue.replace(/\r/g,"<br>");
            cellvalue=cellvalue.replace(/\n/g,"");
            
			if (fieldtype == "2" && htmltype == "2") {
				var valtargetobj = jQuery("textarea[name='"+uservalue+"']");
				if (!!valtargetobj[0]) {
					valtargetobj.html(cellvalue);
				} else {
					jQuery("input[name='"+uservalue+"']").val(cellvalue);
				}
			} else {
            	jQuery("input[name='"+uservalue+"']").val(cellvalue);
            }
        }
    }
}


function refresh(obj,fieldid){  
	var ocont=$G(fieldid+"file");
    oPopup.show(lefter,topper,250,ocont.offsetHeight, document.ChinaExcel);
    //var num=parseInt($G(fieldid+'_num').value);
    var cellval="";
    //if(num>0){
        //addfj(fieldid,num);
        //cellval=frmmain.ChinaExcel.GetCellValue(nowrow,nowcol)+",";
    //}
    ocont.innerHTML=oPopup.document.body.innerHTML;
    //$G(fieldid+'_num').value=num+1;
    var objvalue=obj.value;
    frmmain.ChinaExcel.SetCellVal(nowrow,nowcol,cellval+objvalue.substring(objvalue.lastIndexOf("\\")+1));
    frmmain.ChinaExcel.RefreshViewSize();
}
function addfj(fieldid,num){
    var oTable=$G(fieldid+"_tab");
    oRow = oTable.insertRow();
    oCell = oRow.insertCell();
    var oDiv = document.createElement("div");
    var sHtml = "<input type='file' size=15 id='"+fieldid+"_"+(num+1)+"' name='"+fieldid+"_"+(num+1)+"'>";
    oDiv.innerHTML = sHtml;
    oCell.appendChild(oDiv);
}
function delfj(fieldid){
    var oTable=$G(fieldid+"_tab");
    var rows=parseInt($G(fieldid+'_num').value);
    var i;
    if(rows-1>0){
        for(i=(rows-1);i>=0;i--){
           oTable.deleteRow(i);
        }
    }
}
function clearfile(fieldid){
    hidePopup();
    delfj(fieldid);
    $G(fieldid+'_num').value="0";
    frmmain.ChinaExcel.SetCellVal(nowrow,nowcol,"");
    frmmain.ChinaExcel.RefreshViewSize();
}
function rowIns(detailgroup,isedit,rows){
    rowIns(detailgroup,isedit,rows,"");
}
function rowIns(detailgroup,isedit,rows,changefields){
    rowIns(detailgroup,isedit,rows,changefields,"");
}
function rowIns(detailgroup,isedit,rows,changefields,nobodychangattr) 
{
	var num=0;
    var totalrow=0;
    var wcell=frmmain.ChinaExcel;
	for(j=0;j<rows;j++){		
		var headrow=wcell.GetCellUserStringValueRow("detail"+detailgroup+"_head");
		var nInsertAfterRow=wcell.GetCellUserStringValueRow("detail"+detailgroup+"_end");
		var selcol=wcell.GetCellUserStringValueCol("detail"+detailgroup+"_sel");
        num=parseInt($G("indexnum"+detailgroup).value);
        totalrow=parseInt($G("totalrow"+detailgroup).value);

		//复制行不为空
		if(headrow!=null && headrow!="" && nInsertAfterRow!=null && nInsertAfterRow!=""){
			//将新行加入提交字段



			if($G('submitdtlid'+detailgroup)){
			if($G('submitdtlid'+detailgroup).value==''){
				$G('submitdtlid'+detailgroup).value=num;
			}else{
				$G('submitdtlid'+detailgroup).value+=","+num;
			}
			}

            var workflowid=0;
			var nodeid=0;
			var stringseldefieldsadd="";
			var bodychangattrstr="";
			if($G("workflowid")){
				workflowid=$G("workflowid").value;
			}
			if($G("nodeid")){
				nodeid=$G("nodeid").value;
			}
			if($G("stringseldefieldsadd")){
				stringseldefieldsadd=$G("stringseldefieldsadd").value;
			}

			//加入明细行id空值字段



			adddetail("dtl_id_"+detailgroup+"_"+num,"","","");

			var nInsertRows=rowgroup[detailgroup];
			wcell.SetCanRefresh(false);
			//插入空行
			wcell.SetRowHide(headrow+1,headrow+nInsertRows,false);
            wcell.InsertFormatRows(nInsertAfterRow-1,nInsertRows,headrow+1,headrow+nInsertRows);
			//wcell.InsertFormatRows(nInsertAfterRow-1,nInsertRows,nInsertAfterRow-1,nInsertAfterRow);
			wcell.SetRowHide(headrow+1,headrow+nInsertRows,true);
			//列循环



			var initDetailFields = "";
			for(i=0;i<=wcell.GetMaxCol();i++){
                for(k=0;k<nInsertRows;k++){
                //获得cell对象
				var userstr=wcell.GetCellUserStringValue(nInsertAfterRow+k,i);
                var usershowtype=wcell.GetCellUserValue(nInsertAfterRow+k,i);
                if(userstr!=null && userstr!=""){
					if(userstr.indexOf("_sel")>0){
						
						wcell.SetCellCheckBoxValue(nInsertAfterRow+k,i,false);
					}else{
					var leftstr=userstr.substring(0,userstr.indexOf("_")+1);
					var rightstr=userstr.substring(userstr.indexOf("_")+1);
					userstr=leftstr+num+rightstr.substring(rightstr.indexOf("_"));
					var isprotect=wcell.IsCellProtect(nInsertAfterRow+k,i);
                    var values="";
                    var tfieldid=userstr.substring(5,userstr.indexOf("_"));    
                    //设置cell对象
					if(isprotect){
						wcell.SetCellProtect(nInsertAfterRow+k,i,nInsertAfterRow+k,i,false);
					}
                    wcell.SetCellUserStringValue(nInsertAfterRow+k,i,nInsertAfterRow+k,i,userstr);
                    if(isprotect){
						wcell.SetCellProtect(nInsertAfterRow+k,i,nInsertAfterRow+k,i,true);
					}
                    var htmltype=userstr.substring(userstr.lastIndexOf("_")+1);
                    var tempuserstr=userstr.substring(0,userstr.lastIndexOf("_"));
                    var detailtype=tempuserstr.substring(tempuserstr.lastIndexOf("_")+1);
                    if(htmltype==4){
                    		values=wcell.GetCellCheckBoxValue(nInsertAfterRow+k,i);
                        wcell.SetCellCheckBoxValue(nInsertAfterRow+k,i,values);
                        wcell.SetCellProtect(nInsertAfterRow+k,i,nInsertAfterRow+k,i,true);
                        if(values=='true') values = 1;
                        else values = 0;
                    }
					if(htmltype==3 || htmltype==6){
						try{
							if(htmltype==3&&(detailtype==1||detailtype==17||detailtype==165||detailtype==166)&&$G("userid").value!=null)
								values=$G("userid").value;
							else if(htmltype==3&&(detailtype==8||detailtype==135)) values=$G("relatedPrjId").value;
							else if(htmltype==3&&(detailtype==9||detailtype==37)) values=$G("relatedDocId").value;
							else if(htmltype==3&&(detailtype==7||detailtype==18)) values=$G("relatedCrmId").value;
							// 加上 分权单分部   分权多分部两个类型



							else if(htmltype==3&& (detailtype==164 || detailtype==169 || detailtype==170 || detailtype==194)) values=$G("subcompanyidofuser").value;
							else if(htmltype==3&&(detailtype==4||detailtype==57||detailtype==167||detailtype==168)) values=$G("departmentidofuser").value;
                            else if(htmltype==3&&(detailtype==24||detailtype==278)) {
                            	values=$G("jobtitleidofdefaultuser").value;
                            }
							else values=wcell.GetCellValue(nInsertAfterRow+k,i);
							}catch(e){}
                        wcell.SetCellProtect(nInsertAfterRow+k,i,nInsertAfterRow+k,i,true);
                        
                        if(htmltype==6){
                        	//wcell.SetCellVal(nInsertAfterRow+k,i,"");
                        	//wcell.RefreshViewSize();
                        	values = "";
                        }
                        
                    }
                    if(htmltype==5){
                        values=wcell.GetCellComboSelectedActualValue(nInsertAfterRow+k,i);

						var tempstringseldefieldsadd=","+stringseldefieldsadd+",";
						var temptfieldid=","+tfieldid+",";
						if(tempstringseldefieldsadd.indexOf(temptfieldid)>-1){
							if(nobodychangattr!="1"){
								bodychangattrstr+="changeshowattrBymode('"+tfieldid+"_1','"+values+"',"+num+","+workflowid+","+nodeid+");";
							}
						}
						try{
							var rownum = num;
							//doInitDetailchildSelectAdd(tfieldid,values,rownum)
							var tmp = "doInitDetailchildSelectAdd(" + tfieldid + "," + values + "," + rownum + ");"
							eval(tmp);
						}catch(e){}
                    }
                    var oldfieldshowattr="";
                    //是否为联动字段改变的字段，是则隐藏字段的显示属性值，“显示属性_字段名称”



                    if((changefields+",").indexOf(tfieldid)>=0) oldfieldshowattr=nInsertRows+"|"+usershowtype+"|"+userstr;    
                    //在隐藏table中加入相同空对象
                    adddetail(leftstr+num,values,oldfieldshowattr,htmltype);
                    initDetailFields += leftstr+num+",";
                    if(usershowtype==2){
						var checkfield=$G("needcheck").value;	
						$G("needcheck").value=checkfield+","+leftstr+num;
                        if(htmltype==3 || htmltype==6){
                            wcell.ReadHttpImageFile("/images/BacoBrowser_b_wev8.gif",nInsertAfterRow+k,i,true,true);
                        }else if(htmltype==5&&values>-1&&values!=''){
                             wcell.DeleteCellImage(nInsertAfterRow+k,i,nInsertAfterRow+k,i);
                        }else{
                            wcell.ReadHttpImageFile("/images/BacoError_wev8.gif",nInsertAfterRow+k,i,true,true);
                        }
                    }
                    imgshoworhide(nInsertAfterRow+k,i);
					}
				}
			    }
            }
            
			if(isedit!=1){
			 //wcell.GoToCell(nInsertAfterRow,selcol);
			wcell.SetCellCheckBoxValue(nInsertAfterRow,selcol,false);
			datainputd(initDetailFields);
			}
			wcell.SetCanRefresh(true);			
			wcell.RefreshViewSize();			
			wcell.ReCalculate();
			num++;
            totalrow++;
            $G("indexnum"+detailgroup).value=num;
            $G("nodesnum"+detailgroup).value=num;
            $G("totalrow"+detailgroup).value=totalrow;

			if(bodychangattrstr!=""){
				eval(bodychangattrstr);
			}
		}
	}
}
//在hidden_tab中装载空值字段，每字段占用一行



function adddetail(fieldname,values,oldfieldshowattr,htmltype){
	var tempfieldname = "";
	if(fieldname.length > 7){
		tempfieldname = fieldname.substring(0,7);
	}
	var isDel_id = false;
	var temmtitlevalue="";
	if(tempfieldname != "dtl_id_"){
		tempfieldname = fieldname.substring(0, fieldname.indexOf("_"));
		try{
			temmtitlevalue = document.getElementsByName("temp_"+tempfieldname)[0].value;
		}catch(e){}
	}else{
		isDel_id = true;
	}

	value_field = values;
	var fieldid = "";
	if(isDel_id == false){
		try{
			fieldid = fieldname.substring(5,fieldname.indexOf("_"));
	        indexOfFieldid = inoperatefieldArray.indexOf(fieldid);
			if(indexOfFieldid>-1){
				value_field = inoperatevalueArray[indexOfFieldid];
			}
		}catch(e){}
	}
	try{
		if(fieldid!="" && temmtitlevalue==""){
			temmtitlevalue = document.getElementsByName("field"+fieldid)[0].getAttribute("temptitle");
		}
	}catch(e){}
    var oTable=$G("hidden_tab");
    oRow = oTable.insertRow();
	oRow.id="tr"+fieldname;
    oCell = oRow.insertCell();
    var oDiv = document.createElement("div");
    var sHtml = "";
    if(isDel_id == true){
    	sHtml = "<input type='hidden' id='"+fieldname+"' name='"+fieldname+"' value='"+value_field+"'>";
    }else{
	    sHtml = "<input type='text' temptitle='"+temmtitlevalue+"' id='"+fieldname+"' name='"+fieldname+"' value='"+value_field+"'>";
	    if(oldfieldshowattr!=null&&oldfieldshowattr!=""){
	        sHtml+="<input type='hidden' id='old"+fieldname+"' name='old"+fieldname+"' value='"+oldfieldshowattr+"'>";
	    }
	    if(htmltype==3){
	        sHtml+="<input type='hidden' name='"+fieldname+"_url' value=''><input type='hidden' name='"+fieldname+"_urllink' value=''>";
	    }
    }
    oDiv.innerHTML = sHtml;
    oCell.appendChild(oDiv);
    //if(isDel_id == false){
		//DataInputByBrowser(fieldname);
    //}
}
//在hidden_tab中删除字段



function deldetail(fieldname){
    var oTable=$G("hidden_tab");
	var rows=oTable.rows;
    var checkfield=$G("needcheck").value+",";
    for(var i=0;i<rows.length;i++){
		if(rows[i].id=="tr"+fieldname){
			var tag=","+fieldname+",";
            checkfield=checkfield.replace(tag,",");
            $G("needcheck").value=checkfield.substr(0,checkfield.length-1);
            oTable.deleteRow(i);
		}
	}
}
function checktimeok(){//结束日期不能小于开始日期 -->
    return true;
}

//角色人员字段选择框
function onShowResourceRole(url,fieldid,type1,ismand,nowrow,nowcol,roleid) {
    var tmpids = document.all(fieldid).value;
    url=url + roleid + "_" + tmpids;
    var id1 = window.showModalDialog(url);
    if (!!id1) {
	    if (id1.id != ""  && id1.id != "0" ) {
            var resourceids = id1.id;
		    var resourcename = id1.name;
		    var sHtml = "";
		    document.all(fieldid).value= resourceids;
		    var ids = resourceids.split(",");
		    var names = resourcename.split(",");

		    for (var i=0; i<ids.length; i++) {
		        var curid = ids[i];
		        var curname = names[i];
				if(i == ids.length -1){
		            sHtml = sHtml + curname;
				}else{
                    sHtml = sHtml + curname + ",";
				}
            }
	frmmain.ChinaExcel.SetCellVal(nowrow,nowcol,getChangeField(sHtml));
	} else {
	    if( ismand == 0 ){
		    frmmain.ChinaExcel.SetCellVal( nowrow,nowcol, "");
		}else{
			frmmain.ChinaExcel.SetCellVal (nowrow,nowcol, "");
		}
			document.all(fieldid).value="";
	}
		imgshoworhide(nowrow,nowcol);
		frmmain.ChinaExcel.RefreshViewSize;
	}
}

function chinaexcelregedit(){
    frmmain.ChinaExcel.Login("泛微软件","891e490cd34e3e33975b1b7e523e8b32","上海泛微网络技术有限公司");
}
function changeshowattrBymode(fieldid,fieldvalue,rownum,workflowid,nodeid){
    len = document.forms[0].elements.length;
    var ajax=ajaxinit();
    ajax.open("POST", "/workflow/request/WorkflowChangeShowAttrAjax.jsp", true);
    ajax.setRequestHeader("Content-Type","application/x-www-form-urlencoded");
    ajax.send("workflowid="+workflowid+"&nodeid="+nodeid+"&fieldid="+fieldid+"&fieldvalue="+fieldvalue);
    //获取执行状态



    ajax.onreadystatechange = function() {
        //如果执行状态成功，那么就把返回信息写到指定的层里



        if (ajax.readyState == 4 && ajax.status == 200) {
            try{
            var allreturnvalues=ajax.responseText;
            var allreturnvaluesarray=allreturnvalues.split("+");
            for(t=0;t<allreturnvaluesarray.length;t++){
            
            var returnvalues = allreturnvaluesarray[t];
            if(returnvalues!=""){
                //var tfieldid=fieldid.split("_");
                //var isdetail=tfieldid[1];
                var fieldarray=returnvalues.split("&");
                for(n=0;n<fieldarray.length;n++){
                    var fieldattrs=fieldarray[n].split("$");
                    var fieldids=fieldattrs[0];
                    var fieldattr=fieldattrs[1];
                    var fieldidarray=fieldids.split(",");
                    if(fieldattr==-1){ //没有设置联动，恢复原值和恢复原显示属性



                        for(i=0;i<len;i++){
                            for(j=0;j<fieldidarray.length;j++){
                                var tfieldidarray=fieldidarray[j].split("_");
                                if (tfieldidarray[1]==tfieldidarray[1]){
                                    if(rownum>-1){  //明细字段
                                        if(document.forms[0].elements[i].name=='field'+tfieldidarray[0]+"_"+rownum&&$G('oldfield'+tfieldidarray[0]+"_"+rownum)){
                                            oldfieldview=$G('oldfield'+tfieldidarray[0]+"_"+rownum).value;
                                            oldfieldviewarry=oldfieldview.split("|");
                                            if(oldfieldviewarry.length>1){
                                                var insertrows=oldfieldviewarry[0];
                                                var isedit=oldfieldviewarry[1];
                                                var changefieldid=oldfieldviewarry[2];
                                                var nowrow=frmmain.ChinaExcel.GetCellUserStringValueRow(changefieldid);
                                                var nowcol=frmmain.ChinaExcel.GetCellUserStringValueCol(changefieldid);
                                                if(rownum==0){
                                                    nowrow=parseInt(nowrow)+parseInt(insertrows);
                                                }
                                                var checkstr_=$G("needcheck").value+",";
                                                if(isedit==2){
                                                    imgshowChange(nowrow,nowcol,2);
                                                    if(checkstr_.indexOf("field"+tfieldidarray[0]+"_"+rownum+",")<0) $G("needcheck").value=checkstr_+"field"+tfieldidarray[0]+"_"+rownum;
                                                }
                                                if(isedit==1){
                                                    imgshowChange(nowrow,nowcol,1);
                                                    $G("needcheck").value=checkstr_.replace(new RegExp("field"+tfieldidarray[0]+"_"+rownum+",","g"),"");
                                                }
                                            }
                                        }
                                    }else{     //主字段



                                        if(document.forms[0].elements[i].name=='field'+tfieldidarray[0]&&$G('oldfield'+tfieldidarray[0])){
                                            oldfieldview=$G('oldfield'+tfieldidarray[0]).value;
                                            oldfieldviewarry=oldfieldview.split("|");
                                            if(oldfieldviewarry.length>1){
                                                var isedit=oldfieldviewarry[1];
                                                var changefieldid=oldfieldviewarry[2];
                                                var nowrow=frmmain.ChinaExcel.GetCellUserStringValueRow(changefieldid);
                                                var nowcol=frmmain.ChinaExcel.GetCellUserStringValueCol(changefieldid);
                                                var checkstr_=$G("needcheck").value+",";
                                                if(isedit==2) {
                                                    imgshowChange(nowrow,nowcol,2);
                                                    if(checkstr_.indexOf("field"+tfieldidarray[0]+",")<0) $G("needcheck").value=checkstr_+"field"+tfieldidarray[0];
                                                }
                                                if(isedit==1) {
                                                    imgshowChange(nowrow,nowcol,1);
                                                    $G("needcheck").value=checkstr_.replace(new RegExp("field"+tfieldidarray[0]+",","g"),"");
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                    if(fieldattr==1){//为编辑，显示属性设为编辑



                        for(i=0;i<len;i++){
                            for(j=0;j<fieldidarray.length;j++){
                                var tfieldidarray=fieldidarray[j].split("_");
                                if (tfieldidarray[1]==tfieldidarray[1]){
                                    if(rownum>-1){  //明细字段
                                        if(document.forms[0].elements[i].name=='field'+tfieldidarray[0]+"_"+rownum&&$G('oldfield'+tfieldidarray[0]+"_"+rownum)){
                                            oldfieldview=$G('oldfield'+tfieldidarray[0]+"_"+rownum).value;
                                            oldfieldviewarry=oldfieldview.split("|");
                                            if(oldfieldviewarry.length>1&&oldfieldviewarry[1]>0){
                                                var insertrows=oldfieldviewarry[0];
                                                var changefieldid=oldfieldviewarry[2];
                                                var nowrow=frmmain.ChinaExcel.GetCellUserStringValueRow(changefieldid);
                                                var nowcol=frmmain.ChinaExcel.GetCellUserStringValueCol(changefieldid);
                                                var checkstr_=$G("needcheck").value+",";
                                                if(rownum==0){
                                                    nowrow=parseInt(nowrow)+parseInt(insertrows);
                                                }
                                                imgshowChange(nowrow,nowcol,1);
                                                $G("needcheck").value=checkstr_.replace(new RegExp("field"+tfieldidarray[0]+"_"+rownum+",","g"),"");
                                            }
                                        }
                                    }else{     //主字段



                                        if(document.forms[0].elements[i].name=='field'+tfieldidarray[0]&&$G('oldfield'+tfieldidarray[0])){
                                            oldfieldview=$G('oldfield'+tfieldidarray[0]).value;
                                            oldfieldviewarry=oldfieldview.split("|");
                                            if(oldfieldviewarry.length>1&&oldfieldviewarry[1]>0){
                                                var changefieldid=oldfieldviewarry[2];
                                                var nowrow=frmmain.ChinaExcel.GetCellUserStringValueRow(changefieldid);
                                                var nowcol=frmmain.ChinaExcel.GetCellUserStringValueCol(changefieldid);
                                                var checkstr_=$G("needcheck").value+",";
                                                imgshowChange(nowrow,nowcol,1);
                                                $G("needcheck").value=checkstr_.replace(new RegExp("field"+tfieldidarray[0]+",","g"),"");
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                    if(fieldattr==2){//为必填，显示属性设为编辑



                        for(i=0;i<len;i++){
                            for(j=0;j<fieldidarray.length;j++){
                                var tfieldidarray=fieldidarray[j].split("_");
                                if (tfieldidarray[1]==tfieldidarray[1]){
                                    if(rownum>-1){  //明细字段
                                        if(document.forms[0].elements[i].name=='field'+tfieldidarray[0]+"_"+rownum&&$G('oldfield'+tfieldidarray[0]+"_"+rownum)){
                                            oldfieldview=$G('oldfield'+tfieldidarray[0]+"_"+rownum).value;
                                            oldfieldviewarry=oldfieldview.split("|");
                                            if(oldfieldviewarry.length>1&&oldfieldviewarry[1]>0){
                                                var insertrows=oldfieldviewarry[0];
                                                var changefieldid=oldfieldviewarry[2];
                                                var nowrow=frmmain.ChinaExcel.GetCellUserStringValueRow(changefieldid);
                                                var nowcol=frmmain.ChinaExcel.GetCellUserStringValueCol(changefieldid);
                                                if(rownum==0){
                                                    nowrow=parseInt(nowrow)+parseInt(insertrows);
                                                }
                                                var checkstr_=$G("needcheck").value+",";
                                                imgshowChange(nowrow,nowcol,2);
                                                if(checkstr_.indexOf("field"+tfieldidarray[0]+"_"+rownum+",")<0) $G("needcheck").value=checkstr_+"field"+tfieldidarray[0]+"_"+rownum;
                                            }
                                        }
                                    }else{     //主字段



                                        if(document.forms[0].elements[i].name=='field'+tfieldidarray[0]&&$G('oldfield'+tfieldidarray[0])){
                                            oldfieldview=$G('oldfield'+tfieldidarray[0]).value;
                                            oldfieldviewarry=oldfieldview.split("|");
                                            if(oldfieldviewarry.length>1&&oldfieldviewarry[1]>0){
                                                var changefieldid=oldfieldviewarry[2];
                                                var nowrow=frmmain.ChinaExcel.GetCellUserStringValueRow(changefieldid);
                                                var nowcol=frmmain.ChinaExcel.GetCellUserStringValueCol(changefieldid);
                                                var checkstr_=$G("needcheck").value+",";
                                                imgshowChange(nowrow,nowcol,2);
                                                if(checkstr_.indexOf("field"+tfieldidarray[0]+",")<0) $G("needcheck").value=checkstr_+"field"+tfieldidarray[0];
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                    if(fieldattr==3){//为只读，显示属性设为编辑



                        for(i=0;i<len;i++){
                            for(j=0;j<fieldidarray.length;j++){
                                var tfieldidarray=fieldidarray[j].split("_");
                                if (tfieldidarray[1]==tfieldidarray[1]){
                                    if(rownum>-1){  //明细字段
                                        if(document.forms[0].elements[i].name=='field'+tfieldidarray[0]+"_"+rownum&&$G('oldfield'+tfieldidarray[0]+"_"+rownum)){
                                            oldfieldview=$G('oldfield'+tfieldidarray[0]+"_"+rownum).value;
                                            oldfieldviewarry=oldfieldview.split("|");
                                            if(oldfieldviewarry.length>1&&oldfieldviewarry[1]>0){
                                                var insertrows=oldfieldviewarry[0];
                                                var changefieldid=oldfieldviewarry[2];
                                                var nowrow=frmmain.ChinaExcel.GetCellUserStringValueRow(changefieldid);
                                                var nowcol=frmmain.ChinaExcel.GetCellUserStringValueCol(changefieldid);
                                                var checkstr_=$G("needcheck").value+",";
                                                if(rownum==0){
                                                    nowrow=parseInt(nowrow)+parseInt(insertrows);
                                                }
                                                imgshowChange(nowrow,nowcol,3);
                                                $G("needcheck").value=checkstr_.replace(new RegExp("field"+tfieldidarray[0]+"_"+rownum+",","g"),"");
                                            }
                                        }
                                    }else{     //主字段



                                        if(document.forms[0].elements[i].name=='field'+tfieldidarray[0]&&$G('oldfield'+tfieldidarray[0])){
                                            oldfieldview=$G('oldfield'+tfieldidarray[0]).value;
                                            oldfieldviewarry=oldfieldview.split("|");
                                            if(oldfieldviewarry.length>1&&oldfieldviewarry[1]>0){
                                                var changefieldid=oldfieldviewarry[2];
                                                var nowrow=frmmain.ChinaExcel.GetCellUserStringValueRow(changefieldid);
                                                var nowcol=frmmain.ChinaExcel.GetCellUserStringValueCol(changefieldid);
                                                var checkstr_=$G("needcheck").value+",";
                                                imgshowChange(nowrow,nowcol,3);
                                                $G("needcheck").value=checkstr_.replace(new RegExp("field"+tfieldidarray[0]+",","g"),"");
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
            
            }
            frmmain.ChinaExcel.Refresh();
            //alert($G("needcheck").value);
            }catch(e){}
        }
    }
}
function imgshowChange(nowrow,nowcol,showtype){
    var cellvalue=frmmain.ChinaExcel.GetCellValue(nowrow,nowcol);
    cellvalue = Simplized(cellvalue);
    var uservalue=frmmain.ChinaExcel.GetCellUserStringValue(nowrow,nowcol);
    if(uservalue!=null && uservalue!="" && uservalue.indexOf("_add")<0 && uservalue.indexOf("_del")<0 && uservalue.indexOf("_head")<0 && uservalue.indexOf("_end")<0 && uservalue.indexOf("_sel")<0&& uservalue.indexOf("_showKeyword")<0){
	       var hiddele=jQuery("input#uservalue_"+uservalue.split("_")[0]);
	        if(hiddele.attr("id"))hiddele.remove();
	        
	        var uservalueArray = uservalue.split("_");
	    	var uservaluelen = uservalueArray.length;
	    	if(uservaluelen==4){
	    		var hiddele=jQuery("input#uservalue_"+uservalueArray[0]+"_"+uservalueArray[1]);
		        if(hiddele.attr("id"))hiddele.remove();
	    	}else{
	    		var hiddele=jQuery("input#uservalue_"+uservalue.split("_")[0]);
		        if(hiddele.attr("id"))hiddele.remove();
	    	}
	        
			var index=uservalue.lastIndexOf("_");
	        var htmltype=0;
	        if(index>0){
	            htmltype=uservalue.substr(index+1);
	        }
	        var isProtect=frmmain.ChinaExcel.IsCellProtect(nowrow,nowcol);
	        if(isProtect){
	           frmmain.ChinaExcel.SetCellProtect(nowrow,nowcol,nowrow,nowcol,false);
	        }
			isProtect=false;
            frmmain.ChinaExcel.SetCellUserValue(nowrow,nowcol,nowrow,nowcol,showtype);
            index=uservalue.indexOf("_");
            if(showtype==2){
            	isProtect=false;
                if(cellvalue==null || cellvalue==""){
                    frmmain.ChinaExcel.DeleteCellImage(nowrow,nowcol,nowrow,nowcol);
                    if(htmltype==3 || htmltype==6){
                        frmmain.ChinaExcel.ReadHttpImageFile("/images/BacoBrowser_b_wev8.gif",nowrow,nowcol,true,true);
	                }else{
                        frmmain.ChinaExcel.ReadHttpImageFile("/images/BacoError_wev8.gif",nowrow,nowcol,true,true);
	                }
	            }
	        }else if(showtype==1){
	        	isProtect=false;
                if(cellvalue==null || cellvalue==""){
                    frmmain.ChinaExcel.DeleteCellImage(nowrow,nowcol,nowrow,nowcol);
                    if(htmltype==3 || htmltype==6){
                        frmmain.ChinaExcel.ReadHttpImageFile("/images/BacoBrowser_wev8.gif",nowrow,nowcol,true,true);
                    }
                }
            }else if(showtype==3){//只读
                if(cellvalue==null || cellvalue==""){
                    frmmain.ChinaExcel.DeleteCellImage(nowrow,nowcol,nowrow,nowcol);
                    if(htmltype==3 || htmltype==6){
                        //frmmain.ChinaExcel.ReadHttpImageFile("/images/BacoBrowser_wev8.gif",nowrow,nowcol,true,true);
                    }
                }
               if(htmltype!=3 && htmltype!=6)isProtect=true;//浏览类型/附件上传不在此处处理
               setFieldOnly(uservalue);
            }
	        if(isProtect){
	           frmmain.ChinaExcel.SetCellProtect(nowrow,nowcol,nowrow,nowcol,true);
	        }
    }
}
//添加临时存储附件上传字段 uservalue内容
function setFieldOnly(uservalue){//浏览按钮只读
	var uservalueArray = uservalue.split("_");
	var uservaluelen = uservalueArray.length;
	if(uservaluelen==4){
		var temp=jQuery("input#uservalue_"+uservalueArray[0]+"_"+uservalueArray[1]);
		if(temp.attr("id"))temp.remove();
		var shtml="<input type='hidden' disabled=true olduservalue='"+uservalueArray[0]+"_"+uservalueArray[1]+"' id='uservalue_"+uservalueArray[0]+"_"+uservalueArray[1]+"'/>";
		jQuery("body").append(shtml);
	}else{
		var temp=jQuery("input#uservalue_"+uservalue.split("_")[0]);
		if(temp.attr("id"))temp.remove();
		var shtml="<input type='hidden' disabled=true olduservalue='"+uservalue.split("_")[0]+"' id='uservalue_"+uservalue.split("_")[0]+"'/>";
		jQuery("body").append(shtml);
	}
	
}
function isHiddenPop(uservalue){
	var uservalueArray = uservalue.split("_");
	var uservaluelen = uservalueArray.length;
	if(uservaluelen==2){
		var temp=jQuery("input#uservalue_"+uservalueArray[0]+"_"+uservalueArray[1]);
		return (temp.attr("olduservalue")==uservalueArray[0]+"_"+uservalueArray[1]);
	}

	var temp=jQuery("input#uservalue_"+uservalue.split("_")[0]);
	return (temp.attr("olduservalue")==uservalue.split("_")[0]);
}
function getFirstRowNo(objid){
    var rowno=frmmain.ChinaExcel.GetCellUserStringValueRow (objid)
    var objidary=objid.split("_");
    if(objidary[1]==0){
        rowno=FirstRowNo(objid);
    }
    return rowno;
}
function resetsubmitdtlid(tmpstr){
	var tsz = tmpstr.split("_");
	var delid_tmp = tsz[0];
	var groupid_tmp = tsz[1];
	var submitdtlidArray=$G("submitdtlid"+groupid_tmp).value.split(",");
    $G("submitdtlid"+groupid_tmp).value="";
    var k;
    for(k=0; k<submitdtlidArray.length; k++){
        if(submitdtlidArray[k]!=delid_tmp){
            if($G("submitdtlid"+groupid_tmp).value==''){
                $G("submitdtlid"+groupid_tmp).value = submitdtlidArray[k];
            }else{
                $G("submitdtlid"+groupid_tmp).value += ","+submitdtlidArray[k];
            }
        }
    }
}

function json2String(josinobj) {
	if (josinobj == undefined || josinobj == null) {
		return "";
	}
	var ary = "";
	var _index = 0;
	try {
		for(var key in josinobj){
			if (_index++ > 0) {
				if (!!key && key.indexOf(",") == 0) {
					key = key.substr(1);
				}
				
				ary += "(~!@#$%^&*)";
			}
			var jsonval = josinobj[key] ;
			if (!!jsonval && jsonval.indexOf(",") == 0) {
				jsonval = jsonval.substr(1);
			}
			ary += jsonval;
		}
	} catch (e) {}
	return ary;
}

function showCustomizeBrowserNew(url,fieldid,type1,ismand,nowrow,nowcol){
	var obj = new Object(); 
	obj.document=document; 
	var id1 = window.showModalDialog(url,obj);
	if (id1 != null) {
		var id = wuiUtil.getJsonValueByIndex(id1,0);
		var name = wuiUtil.getJsonValueByIndex(id1,1);
		if(id != 0 && id != ''){
            document.all(fieldid).value= id;
            frmmain.ChinaExcel.SetCellVal(nowrow,nowcol,name);
		}else{
	   	   	frmmain.ChinaExcel.SetCellVal(nowrow,nowcol,"");
            document.all(fieldid).value="";
		}
	    onShowFnaInfo(fieldid,nowrow);
        imgshoworhide(nowrow,nowcol);
        frmmain.ChinaExcel.RefreshViewSize();
	}
	DataInputByBrowser(fieldid); 
}