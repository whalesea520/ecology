


//得到时间
function getDate(i){
	datas = window.showModalDialog("/systeminfo/Calendar.jsp","","dialogHeight:320px;dialogwidth:275px");
	$("#datespan"+i).html(datas.name);
	$("input[name=dff0"+i+"]").val(datas.id);
}



//列表中显示开始日期
function onShowBeginDate1(returndate,txtObj,spanObj,endDateObj,spanEndDateObj,timeObj,timespanObj,endtimeObj,endtimespanObj,workLongObj){
	var diffDate="";	
	if (returndate){
		if (returndate!=""){
			endDate = endDateObj.value;			
			
			if (endDate != "" ){//&& endtimeObj.value!="" && timeObj.value !=""
				if(endtimeObj.value!="" && timeObj.value !=""){
					diffDate = dateDiffForJava(returndate,endDate,timeObj.value,endtimeObj.value);
				}else if(endtimeObj.value=="" &&  timeObj.value!=""){
					diffDate = dateDiffForJava(returndate,endDate,timeObj.value,"23:59");
				}else if(endtimeObj.value!="" &&  timeObj.value==""){
					diffDate = dateDiffForJava(returndate,endDate,"00:00",endtimeObj.value);
				}else if(endtimeObj.value=="" &&  timeObj.value==""){
					diffDate = dateDiffForJava(returndate,endDate,"00:00","23:59");
				}
				 
				if (diffDate<0){
					if(diffDate==-1){
						/*if(readCookie("languageidweaver")==8){
							alert("The end date must be larger than the start date!")
	                        $(spanObj).html(txtObj.value);
						}
						else{
							alert("结束日期必须大于开始日期！")
							$(spanObj).html(txtObj.value);
						}*/
						alert(SystemEnv.getHtmlNoteName(54,readCookie("languageidweaver")));
						$(spanObj).html(txtObj.value);

					}else if(diffDate==-2){
						/*if(readCookie("languageidweaver")==8){
							alert("The end time must be larger than the start time!")
	                        $(spanObj).html(txtObj.value);
						}
						else{
							alert("结束时间必须大于开始时间！")
							$(spanObj).html(txtObj.value);
						}*/
						alert(SystemEnv.getHtmlNoteName(55,readCookie("languageidweaver")));
						$(spanObj).html(txtObj.value);
					}
				}else {
					$(spanObj).html(returndate);
					$(txtObj).val(returndate);
					$(workLongObj).val(diffDate);
				}
			} else {
					if  (workLongObj.value!="" && workLongObj.value > 0 ){
					$(spanObj).html(returndate);
					$(txtObj).val(returndate);
					onWorkLongChange(workLongObj,txtObj,spanObj,endDateObj,spanEndDateObj,timeObj,timespanObj,endtimeObj,endtimespanObj);
						//newDate = getAddNewDateStr1(returndate,workLongObj.value)
						//$(spanEndDateObj).html(newDate);
						//$(endDateObj).val(newDate);
					}
					
					$(spanObj).html(returndate);
					$(txtObj).val(returndate);        
			}
		}else{
			$(spanObj).html( "");
			$(txtObj).val("" );
		} 
	}
}

//列表中显示结束日期
function onShowEndDate1(returndate,txtObj,spanObj,beginDateObj,spanBeginDateObj,endtimeObj,endtimespanObj,timeObj,timespanObj,workLongObj){
		var diffDate="";
		if (returndate){
		if (returndate!=""){
			beginDate = beginDateObj.value
			begintime = timeObj.value
			endtime = endtimeObj.value
			if (beginDate != ""  ){
				if(endtime!="" && begintime !=""){
					diffDate = dateDiffForJava(beginDate,returndate,begintime,endtime);
				}else if(endtime=="" && begintime!=""){
					diffDate = dateDiffForJava(beginDate,returndate,begintime,"23:59");
				}else if(endtime!="" && begintime==""){
					diffDate = dateDiffForJava(beginDate,returndate,"00:00",endtime);
				}else if(endtime=="" && begintime==""){
					diffDate = dateDiffForJava(beginDate,returndate,"00:00","23:59");
				}
				 
				if (diffDate<0){
					if(diffDate==-1){
						/*if(readCookie("languageidweaver")==8){
							alert("The end date must be larger than the start date!")
							//spanObj.innerHtml = txtObj.value
							 $(spanObj).html(txtObj.value);
						}else{
							alert("结束日期必须大于开始日期！")
							//spanObj.innerHtml = txtObj.value
							$(spanObj).html(txtObj.value);
						}*/
						alert(SystemEnv.getHtmlNoteName(54,readCookie("languageidweaver")));
						$(spanObj).html(txtObj.value);
					}else if(diffDate==-2){
						/*if(readCookie("languageidweaver")==8){
							alert("The end time must be larger than the start time!")
						//	spanObj.innerHtml = txtObj.value
							$(spanObj).html(txtObj.value);
						}else{
							alert("结束时间必须大于开始时间！")
							//spanObj.innerHtml = txtObj.value
							$(spanObj).html(txtObj.value);
						}*/
						alert(SystemEnv.getHtmlNoteName(55,readCookie("languageidweaver")));
						$(spanObj).html(txtObj.value);
					}
				}else {
					spanObj.innerHtml= returndate
					txtObj.value=returndate    
					workLongObj.value=diffDate
				} 
			}else{
					if ( workLongObj.value != ""){
						$(spanObj).html(returndate);
						$(txtObj).val(returndate);
						onWorkLongChange(workLongObj,beginDateObj,spanBeginDateObj,txtObj,spanObj,timeObj,timespanObj,endtimeObj,endtimespanObj);
						//newDate = getSubtrNewDateStr(returndate,workLongObj.value)
						//spanBeginDateObj.innerHtml=newDate
						//beginDateObj.value=newDate
					}

					spanObj.innerHtml= returndate
					txtObj.value=returndate    
			}
		}else{
			spanObj.innerHtml= ""
			txtObj.value="" 
		}
		}
}



//列表中显示开始时间
function onShowBeginTime1(returndate,txtObj,spanObj,endDateObj,spanEndDateObj,timeObj,timespanObj,endtimeObj,endtimespanObj,workLongObj,oldvalue){
	var diffDate="";
	if (returndate){
		if (returndate!=""){
			endDate = endDateObj.value;			
			if (endDate != "" && endtimeObj.value !="" && txtObj.value!=""){
				diffDate = dateDiffForJava(txtObj.value,endDate,returndate,endtimeObj.value);
				if (diffDate<0){
					/*if(readCookie("languageidweaver")==8){
						alert("The end time must be larger than the start time!")
                        $(spanObj).html(timespanObj.value);
					}
					else{
						alert("结束时间必须大于开始时间！")
						$(spanObj).html(timespanObj.value);
					}*/
					alert(SystemEnv.getHtmlNoteName(55,readCookie("languageidweaver")));					
					$(timespanObj).html(oldvalue);
					$(timeObj).val(oldvalue);
				}else {
				//	$(spanObj).html(returndate);
				//	$(txtObj).val(returndate);
					$(workLongObj).val(diffDate);
				}
			} else {
					if  (workLongObj.value!="" ){
						//newDate = getAddNewDateStr1(returndate,workLongObj.value)
						//$(spanEndDateObj).html(newDate);
						//$(endDateObj).val(newDate);
					}
					
				///	$(spanObj).html(returndate);
				//	$(txtObj).val(returndate);        
			}
		}else{
			$(timespanObj).html( "");
			$(timeObj).val("" );
		} 
	}
}


//列表中显示结束时间
function onShowEndTime1(returndate,txtObj,spanObj,beginDateObj,spanBeginDateObj,endtimeObj,endtimespanObj,timeObj,timespanObj,workLongObj,oldvalue){
	var diffDate="";
	if (returndate){
		if (returndate!=""){
			 beginDate = beginDateObj.value;			
			if (beginDate != "" && txtObj.value!="" && timeObj.value!=""){
				diffDate = dateDiffForJava(beginDate,txtObj.value,timeObj.value,returndate);
				 
				if (diffDate<0){
					/*if(readCookie("languageidweaver")==8){
						alert("The end time must be larger than the start time!")
                        $(endtimespanObj).html(timespanObj.value);
					}
					else{
						alert("结束时间必须大于开始时间！")
						$(endtimespanObj).html(timespanObj.value);
					}*/
					alert(SystemEnv.getHtmlNoteName(55,readCookie("languageidweaver")));
					$(endtimespanObj).html(oldvalue);
					$(endtimeObj).val(oldvalue);
				}else {
				//	$(spanObj).html(returndate);
				//	$(txtObj).val(returndate);
					$(workLongObj).val(diffDate);
				}
			} else {
					if  (workLongObj.value!="" ){
						//newDate = getAddNewDateStr1(returndate,workLongObj.value)
						//$(spanEndDateObj).html(newDate);
						//$(endDateObj).val(newDate);
					}
					
				///	$(spanObj).html(returndate);
				//	$(txtObj).val(returndate);        
			}
		}else{
			$(endtimespanObj).html( "");
			$(endtimeObj).val("" );
		} 
	}
}

//当改变工期时做以下操作
function onWorkLongChange(workLongObj,beginDateObj,spanBeginDateObj,endDateObj,spanEndDateObj,begintimeObj,spanbegintimeObj,endtimeObj,spanendtimeObj){
	var prjmanager  = document.getElementById("prjmanager"); 
	var passnoworktime  = document.getElementById("passnoworktime"); 
	
	var prjmanagervalue="";
	var passnoworktimevalue = "";
	
	if (prjmanager&&passnoworktime){ //编辑
		 prjmanagervalue = prjmanager.value; 
		 passnoworktimevalue = passnoworktime.value;
		 if(passnoworktimevalue==1){
		 	passnoworktimevalue = true;
		 }else{
		 	passnoworktimevalue = false;
		 }	 
	} else{//新建
		prjmanagervalue=parent.document.getElementById("manager").value;
	 	passnoworktimevalue= parent.document.getElementById("passnoworktime").checked;
	}
	workLong = workLongObj.value
	beginDate = beginDateObj.value
	endDate = endDateObj.value
	begintime = begintimeObj.value
	endtime = endtimeObj.value
	
	if(begintime==""){
		begintime = "00:00";
	}

	if(endtime==""){
		endtime = "23:59";
	}
	if(!passnoworktimevalue){
		if (workLong!="" && workLong >0 && beginDate!=""){
			newDate = getBeginDateTime(beginDate,workLong,begintime)
			newDatespl = newDate.split(" ");
			spanEndDateObj.innerHTML=newDatespl[0]
			endDateObj.value=newDatespl[0]
			spanendtimeObj.innerHTML=newDatespl[1]
			endtimeObj.value=newDatespl[1]
			return;
		}
		if (workLong!="" && workLong >0 && endDate!=""){
			newDate = getEndDateTime(endDate,-(workLong),endtime)
			newDatespl = newDate.split(" ");
			$(spanBeginDateObj).html(newDatespl[0]);
			$(beginDateObj).val(newDatespl[0]);
			$(spanbegintimeObj).html(newDatespl[1]);
			$(begintimeObj).val(newDatespl[1]);
			return;
		}
	}else{//跳过非工作日
		if (workLong!="" && workLong >0 && beginDate!=""){//计算结束日期
			 $.ajax({
	           type: "post",
	           url: "/proj/process/GetDateByWorkLong.jsp",
	           data:"method=getEndDate&workLong="+workLong+"&begindate="+beginDate+"&begintime="+begintime+"&manager="+prjmanagervalue,
	           dataType: "text", 
	           async:false,
	           success:function(data){
	           		alldate = data.trim();
	           }
	       });
			
			//newDate = getDateTime(beginDate,workLong,begintime)
			//alert(alldate);
			newDatespl = alldate.split(" ");
			spanEndDateObj.innerHTML=newDatespl[0]
			endDateObj.value=newDatespl[0]
			spanendtimeObj.innerHTML=newDatespl[1]
			endtimeObj.value=newDatespl[1]
			return;
		}
		
		
		if (workLong!="" && workLong >0 && endDate!=""){
		 $.ajax({
	           type: "post",
	           url: "/proj/process/GetDateByWorkLong.jsp",
	           data:"method=getBeginDate&workLong="+workLong+"&enddate="+endDate+"&endtime="+endtime+"&manager="+prjmanagervalue,
	           dataType: "text", 
	           async:false,
	           success:function(data){
	           		alldate = data.trim();
	           }
	       });
		
			//newDate = getDateTime(endDate,-(workLong),endtime)
			//alert(alldate);
			newDatespl = alldate.split(" ");
			$(spanBeginDateObj).html(newDatespl[0]);
			$(beginDateObj).val(newDatespl[0]);
			$(spanbegintimeObj).html(newDatespl[1]);
			$(begintimeObj).val(newDatespl[1]);
			return;
		}
	}
}
function getBeginDateTime(dd,dadd,bt){
	var arr= dd.split("-");
	var btt = bt.split(":");
	var a = new Date(arr[0],arr[1]-1,arr[2],btt[0],btt[1]).valueOf();
	a = (a + dadd * 24 * 60 * 60 * 1000)-60*1000;
	a = new Date(a);
	return a.format("yyyy-MM-dd hh:mm");
}

function getEndDateTime(dd,dadd,bt){
	var arr= dd.split("-");
	var btt = bt.split(":");
	var a = new Date(arr[0],arr[1]-1,arr[2],btt[0],btt[1]).valueOf();
	a = (a + dadd * 24 * 60 * 60 * 1000)+60*1000;
	a = new Date(a);
	return a.format("yyyy-MM-dd hh:mm");
}


//算新的时间的方法 加法
	function getAddNewDateStr(strDate,addDay){
       if (strDate=""){
			getAddNewDateStr="" 	
			return;
       }
        
		strDateArray = strDate.split("-");
		strYear = strDateArray[0];
		strMonth = strDateArray[1];
		strDay = strDateArray[2];
		myDate2 = new Date();
		myDate2.setYear(strYear);
		myDate2.setMonth(strMonth);
		myDate2.setDate(parseInt(strDay)+addDay);
		myYear = myDate2.getFullYear();
		myMonth= myDate2.getMonth();
		myDay = myDate2.getDate();

		if (myMonth<10){
			newMonth = "0"+ (myMonth);
		}else {
			newMonth = (myMonth)
		}
		if (myDay<10 ){
			 newDay = "0"+ (myDay) 
		}else{
			newDay = (myDay)
		}
		getAddNewDateStr = ""+(myYear)+"-"+newMonth+"-"+newDay;
	return;
}
	
//算新的时间的方法 加法  TD18989
	function getAddNewDateStr1(strDate,addDay){
		if (strDate==""){
			return "" 	;
			
		}
     
		strDateArray = strDate.split("-");
		strYear = strDateArray[0];
		strMonth = strDateArray[1];
		strDay = strDateArray[2];

		//if(parseInt(addDay)>0 && (""+parseInt(addDay)==addDay || ""+(parseInt(addDay))+".0"==addDay)){
		 //  MyDate2 = new Date(parseInt(strYear), parseInt(strMonth), parseInt(strDay)+parseInt(addDay)-1);
		//}else{ 
		//   MyDate2 = new Date(parseInt(strYear), parseInt(strMonth), parseInt(strDay)+parseInt(addDay))
		//}   
		 var durnum = parseInt(addDay);
		 var MyDate2 = new Date();
		 if(parseInt(addDay)>0 && (""+parseInt(addDay)==addDay || ""+(parseInt(addDay))+".0"==addDay)){
				durnum = parseInt(addDay)-1;
		 }
		
	
		  var _date = new Date(strYear,strMonth-1,strDay);
		  		 
		  var _today =  parseInt(_date.getTime()/1000);
		  var t=(_today+86400*durnum)*1000;
		  MyDate2.setTime(t);
		  myMonth= MyDate2.getMonth()+1;
		
		
		myYear = MyDate2.getFullYear();
		myDay = MyDate2.getDate();

		if( myMonth<10){
				newMonth = "0"+ (myMonth) ;
		}else{
			newMonth = ""+(myMonth);
		}
		if(myDay<10){
			 newDay = "0"+ (myDay) ;
		}else{
				newDay = (myDay);
		}
		return ""+(myYear)+"-"+newMonth+"-"+newDay;
	}

//算新的时间的方法 减法
	function getSubtrNewDateStr(strDate,addDay){
       if(strDate==""){
			return "";
       }
        
		strDateArray = strDate.split("-");
		strYear = strDateArray[0];
		strMonth = strDateArray[1];
		strDay = strDateArray[2];
		MyDate2 = new Date(parseInt(strYear), parseInt(strMonth), parseInt(strDay)-addDay+1);   		
		myYear = MyDate2.getFullYear();
		myMonth= MyDate2.getMonth();
		myDay = MyDate2.getDate();

		if (myMonth<10){
			 newMonth = "0"+ myMonth; 
		}else{
			 newMonth = ""+myMonth;
		}
		if (myDay<10){
			newDay = "0"+ (myDay) ;
		}else{
			newDay = ""+(myDay);
		}
		return ""+(myYear)+"-"+newMonth+"-"+newDay;
	}

	//项目成员
	function onShowMHrm(txtObj,spanObj,spanObj1,isTemplet){
			tmpids = txtObj.value;
			var id1 = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/MutiResourceBrowser.jsp?resourceids="+tmpids);
	        if (id1) {
					if (id1.id!="") {					
						//oldSelects = getAllSelelt();
						//removeAllManager();
						
						var sHtml = ""
						
						txtObj.value= id1.id.substr(1);
						var resourceids = id1.id.substr(1).split(",");
						var resourcenames = id1.name.substr(1).split(",");
						
						//添加到负责人对象框
						addSelManager(id1.id.substr(1),id1.name.substr(1));	
						
						for(var i=0;i<resourceids.length;i++){
							sHtml=sHtml+"<a href=/hrm/resource/HrmResource.jsp?id="+resourceids[i]+">"+resourcenames[i]+"</a>&nbsp;";
						}
						
						spanObj.innerHTML = sHtml;
						spanObj1.innerHTML = sHtml;
						
						 
						//addSeleValue(oldSelects);		
					}else{
						//removeAllManager();
						if (isTemplet=="false") 
							spanObj.innerHTML ="<IMG src='/images/BacoError_wev8.gif' align='absMiddle'>"
						else
							spanObj.innerHTML =""
						
						spanObj1.innerHTML=""
						txtObj.value=""
					}
	        }
	}	
	
	//用于自定义部分
function onShowBrowser(id,url,linkurl,type1,ismand){
	if (type1==2 || type1 == 19) {
		spanname = "customfield"+id+"span";
	    inputname = "customfield"+id;
		if (type1 == 2){
		  onWorkFlowShowDate(spanname,inputname,ismand);
		}else{
	      onWorkFlowShowTime(spanname,inputname,ismand);
		}
	}else{
		if (type1 != 17 && type1 != 18 && type1!=27 && type1!=37 && type1!=56 && type1!=57 && type1!=65 && type1!=152 && type1!=135&& type1!=168&& type1!=170) {
			id1 = window.showModalDialog(url)
		}else{
			if(37==type1){
				tmpids = document.all("customfield"+id).value
				id1 = window.showModalDialog(url+"?documentids="+tmpids)
			} else {
				tmpids = document.all("customfield"+id).value
				id1 = window.showModalDialog(url+"?resourceids="+tmpids)	
			}
		}
		if (id1) {
			if (type1 == 17 || type1 == 18 || type1==27 || type1==37 || type1==56 || type1==57 || type1==65 || type1==152 || type1==135|| type1==168|| type1==170) {
				if (id1.id!=""  && id1.id!="0"){
					resourceids = id1.id.substr(1).split(",");
					resourcename = id1.name.substr(1).split(",");
					sHtml = "";
					
					for(var i=0;i<resourceids.length;i++){
						sHtml=sHtml+"<a href="+linkurl+resourceids[i]+">"+resourcename[i]+"</a>&nbsp";
					}
					
					document.all("customfield"+id).value= id1.id.substr(1);
					document.all("customfield"+id+"span").innerHTML = sHtml;

				}else{
					if (ismand==0) {
						document.all("customfield"+id+"span").innerHTML = "";
					}else{
						document.all("customfield"+id+"span").innerHTML ="<img src='/images/BacoError_wev8.gif' align=absmiddle>";
					}
					document.all("customfield"+id).value="";
				}

			}else{
			   if  (id1.id!="")  {
			        if (linkurl == "") {
						document.all("customfield"+id+"span").innerHTML = id1.name;
			        }else{
						document.all("customfield"+id+"span").innerHTML = "<a href="+linkurl+id1.id+">"+id1.name+"</a>"
			        }
					document.all("customfield"+id).value=id1.id;
			   }else{
					if (ismand==0) {
						document.all("customfield"+id+"span").innerHTML = "";
					}else{
						document.all("customfield"+id+"span").innerHTML ="<img src='/images/BacoError_wev8.gif' align=absmiddle>";
					}
					document.all("customfield"+id).value="";
			}
			}
		}
	  }	
	}
	
	//项目类型
function onShowPrjTypeID(txtObj,spanObj,spanImgObj,method,templetId){   
	result = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/proj/Maint/ProjectTypeBrowser.jsp?sqlwhere=Where wfid<>0 ");
	if (result) {
        if (result.id!="0") {
            spanObj.innerHTML = result.name;
            txtObj.value=result.id;
			spanImgObj.innerHTML=""
        }else {
            spanObj.innerHTML = "";           
			spanImgObj.innerHTML="<IMG src='/images/BacoError_wev8.gif' align='absMiddle'>";
            txtObj.value="";
        }
	}
}