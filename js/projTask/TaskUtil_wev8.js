function bindMs(obj){
	jQuery(obj).bind("mouseover",function(){$(this).addClass("e8Selected").parent("tr").addClass("Selected");})
	.bind("mouseout",function(){$(this).removeClass("e8Selected").parent("tr").removeClass("Selected");});
}
function addRow(){
        var oRow;      
        oRow = tblTask.insertRow(-1);     
        oRow.className="itemtr DataLight";   
        iRowIndex++ ;
        if(RowindexNum==undefined){
        	RowindexNum=0;
        	iRowIndex=0;
        }
        RowindexNum++;
        oRow.id="tr_"+iRowIndex;
        oRow.customIndex = iRowIndex;
        for (var i = 1; i <= 10; i++) {
            oCell = oRow.insertCell(-1);
    		oCell.align = "left";
           
            var oDiv = document.createElement("div");
            var sHtml=""; 
            switch (i){               
               case 1: //编号	                    
                    //oCell.style.backgroundColor="#e7e7e7";
                    oCell.className="td_drag"; 
					/*if(readCookie("languageidweaver")==8){
						oCell.title="click then move"; 
					}
					if(readCookie("languageidweaver")==9){
						oCell.title="單擊選中然後可拖動";
					}
					else {
						oCell.title="单击选中 然后可拖动";  
					}*/
					oCell.title=SystemEnv.getHtmlNoteName(3431,readCookie("languageidweaver"));
                    //oCell.onclick=function(){onDragTDDBClick(this);};
                    sHtml=RowindexNum+"<input type='hidden' name='templetTaskId' value='-1'><input type='hidden' name='txtRowIndex' id='txtRowindex_"+iRowIndex+"' value='"+iRowIndex+"'>";
                    break ;
                case 2: //checkbox 框	                    
                    sHtml="<input type='checkbox'  name='chkTaskItem' id='chkTaskItem_"+iRowIndex+"' value='"+iRowIndex+"'>";                   
                    break ;
				case 3: //任务名称	
                    oCell.align = "right";
                    //sHtml="<table><tr width='100%'><td><div id='taskNameDiv_"+iRowIndex+"' align='right'  valign='bottom'><img id='img_"+iRowIndex+"' style='visibility:hidden;cursor:pointer' src='/images/project_rank_wev8.gif' onclick='onImgClick(this,"+iRowIndex+")' imgState='show' ><div></td><td><input type='txtTaskName' class='InputStyle'  name='txtTaskName'      id='txtTaskName_"+iRowIndex+"' onchange='onTaskNameChange(this,"+iRowIndex+")' size='24'  customIndex='"+iRowIndex+"'></td></tr></table>";  
                    sHtml="<span id='taskNameDiv_"+iRowIndex+"' align='right'  ><img id='img_"+iRowIndex+"' style='visibility:hidden;cursor:pointer' src='/images/project_rank_wev8.gif' onclick='onImgClick(this,"+iRowIndex+")' imgState='show' ></span><input type='txtTaskName' class='InputStyle'  name='txtTaskName' size='24'  style='width:150px!important;'    id='txtTaskName_"+iRowIndex+"' onchange='onTaskNameChange(this,"+iRowIndex+")'   customIndex='"+iRowIndex+"'>";  
                    break ;
                case 4: //工期						
                    sHtml="<input type='txtWorkLong' class='InputStyle' style='width:50px!important;' name='txtWorkLong'  size='4' id='txtWorkLong_"+iRowIndex+"'  onKeyPress='ItemNum_KeyPress(this)' onchange='onWorkLongChange(this,txtBeginDate_"+iRowIndex+",spanBeginDate_"+iRowIndex+",txtEndDate_"+iRowIndex+",spanEndDate_"+iRowIndex+")'>"; 
                    break ;
                case 5: //开始时间						
                    sHtml="<button type=\"button\" class=Calendar onclick='onShowBeginDate(txtBeginDate_"+iRowIndex+",spanBeginDate_"+iRowIndex+",txtEndDate_"+iRowIndex+",spanEndDate_"+iRowIndex+",txtWorkLong_"+iRowIndex+")'></BUTTON>"+
                          "<SPAN id=spanBeginDate_"+iRowIndex+" ></SPAN>"+
                          "<input type='hidden' name='txtBeginDate' id='txtBeginDate_"+iRowIndex+"'>";                
                    break ;
                case 6: //结束时间						
                   sHtml="<button type=\"button\" class=Calendar onclick='onShowEndDate(txtEndDate_"+iRowIndex+",spanEndDate_"+iRowIndex+",txtBeginDate_"+iRowIndex+",spanBeginDate_"+iRowIndex+",txtWorkLong_"+iRowIndex+")'></BUTTON>"+
                          "<SPAN id=spanEndDate_"+iRowIndex+" ></SPAN>"+
                          "<input type='hidden' name='txtEndDate' id='txtEndDate_"+iRowIndex+"'>";                
                   break ;
                case 7: //前置任务						
                    //sHtml="<select name='seleBeforeTask' id='seleBeforeTask_"+iRowIndex+"'  onchange='onBeforeTaskChange(this,"+iRowIndex+")'><option value='0'></option></select>";
                	sHtml="<button type=\"button\" class=Browser onclick='onSelectBeforeTask(seleBeforeTaskSpan_"+iRowIndex+",seleBeforeTask_"+iRowIndex+")'></button><input type=hidden name='seleBeforeTask' id='seleBeforeTask_"+iRowIndex+"' value=''  onchange='beforeTask_check(this)' ><span id='seleBeforeTaskSpan_"+iRowIndex+"'></span><input type=hidden name='index_"+iRowIndex+"' id='index_"+iRowIndex+"' value='"+iRowIndex+"'>";
                    break ;
                case 8: //预算	 					
                    sHtml="<input type='text' class='InputStyle' style='width:80px!important;' name='txtBudget' size='8' id='txtBudget_"+iRowIndex+"' onKeyPress='ItemNum_KeyPress(this)'>";                
                    break ;
                case 9: //负责人		
                    //sHtml="<select  name='txtManager' id='txtManager_"+iRowIndex+"'  ><option value='0'></option></select>";
                	sHtml="<button type=\"button\" class=Browser onclick='onSelectManager(txtManagerSpan_"+iRowIndex+",txtManager_"+iRowIndex+")'></button><input type=hidden name='txtManager' id='txtManager_"+iRowIndex+"' value=''><span id='txtManagerSpan_"+iRowIndex+"'></span>";
                    break ;
                case 10: //升降级	               
                	var leftarrow=" src='/proj/img/zuo_wev8.png' onmouseover=\"$(this).attr('src','/proj/img/zuo-hot_wev8.png')\" onmouseout=\"$(this).attr('src','/proj/img/zuo_wev8.png')\" ";
                	var rightarrow=" src='/proj/img/you_wev8.png' onmouseover=\"$(this).attr('src','/proj/img/you-hot_wev8.png')\" onmouseout=\"$(this).attr('src','/proj/img/you_wev8.png')\" ";
					if(readCookie("languageidweaver")==8){
						sHtml="<img title='up' "+leftarrow+" border='0' onclick='upLevel("+iRowIndex+")' style='cursor:pointer;width:20px'></img>&nbsp;&nbsp<img  title='down'   "+rightarrow+" border='0'  onclick='downLevel("+iRowIndex+")' style='cursor:pointer;width:20px'></img>";               
					}
					else if(readCookie("languageidweaver")==9)
					{
						sHtml="<img title='"+SystemEnv.getHtmlNoteName(3432,readCookie("languageidweaver"))+"' "+leftarrow+" border='0' onclick='upLevel("+iRowIndex+")' style='cursor:pointer;width:20px'></ img>&nbsp;&nbsp<img title='"+SystemEnv.getHtmlNoteName(3433,readCookie("languageidweaver"))+"' "+rightarrow+" border='0' onclick='downLevel("+iRowIndex+")' style='cursor:pointer;width:20px'></img>";
					}
					else {						
						sHtml="<img title='"+SystemEnv.getHtmlNoteName(3432,readCookie("languageidweaver"))+"' "+leftarrow+" border='0' onclick='upLevel("+iRowIndex+")' style='cursor:pointer;width:20px'></img>&nbsp;&nbsp<img  title='"+SystemEnv.getHtmlNoteName(3433,readCookie("languageidweaver"))+"'     "+rightarrow+" border='0'  onclick='downLevel("+iRowIndex+")' style='cursor:pointer;width:20px'></img>";                      
					}	                    
                    break ;
                default:
                    sHtml=" ";                
                    break ;
            }
            //alert(sHtml)
            oDiv.innerHTML = sHtml;
			oCell.appendChild(oDiv);
			bindMs(oCell);
        }
        //把节点加入文档对像中                 
        addNode(iRowIndex)

        //多加一行
        /**
        oRow = tblTask.insertRow(-1); 
        oRow.className="Line";
        oCell = oRow.insertCell(-1)
        oCell.colSpan="10";
		**/
        //移动到相应的结点下去

      // addRowNeedMove(iRowIndex,lastSelectedTRObj);
    }

    function addOption(idStr,valueStr,rowIndex){
          var txtManagerObj3 = document.getElementById("txtManager_"+rowIndex);                           
          txtManagerObj3.options.add(new Option(valueStr,idStr));
    }

    function removeAllManager(){
    	//修改项目成员时不做任何事情
    }
    
    function getAllSelelt(){
    	var resultStr = "";
    	var txtManagerObjs = document.getElementsByName("txtManager");  
         for (var i=0;i<txtManagerObjs.length;i++){
             var obj = txtManagerObjs[i];
             resultStr += obj.value+"|";
         }
         return resultStr;
    }
    
    function addSeleValue (oldSelectValue){
    	//修改项目成员时不做任何事情    	
    }

	function isContainValue(selectObj,optionValue) {
		for (var i=0;i<selectObj.options.length ;i++ )	{
			var option = selectObj.options.item(i);
			if (option.value==optionValue)	return "true";
		}
		return "false";
	}
    function getObj(objId){
        try {
            var obj = document.getElementById(objId);
            return obj;
        } catch(ex){
            return null;
        }

    }

	function getUseableRowIndex(){
        try {
           var objTRs=tblTask.getElementsByTagName("TR");
		   var returnIndex=null;
		   if(objTRs!=null){
			   for(var i=0;i<objTRs.length;i++){
				   if(i>10) break;				  
				   if(objTRs[i].customIndex!=null) {
					   returnIndex=objTRs[i].customIndex;
					   //alert(objTRs[i].customIndex)
					   break;
				   }
			   }
		   }
		   return returnIndex;
        } catch(ex){
            return null;
        }

    }
     
    function deleteRow(){
		 var message="";
		 /*if(readCookie("languageidweaver")==8){
			message="His children task will be delete,are you sure?"; 
		}
		else if(readCookie("languageidweaver")==9){ 
			message="其子任務也將被刪除,是否繼續?"; 
		}
		else {
			message="其子任务也将被删除,是否继续?";  
		}*/
		message = SystemEnv.getHtmlNoteName(85,readCookie("languageidweaver"));
        if(!confirm(message)) return  ;
        try {
        	var taskItems=jQuery("input[name='chkTaskItem']:checked");
            var delList = getDeleteList(taskItems);
            
            for (var i= 0;i<delList.size();i++){
                var delItem = delList.get(i);  
                
                jQuery("#tr_"+delItem).next().remove();
                jQuery("#tr_"+delItem).remove();  
                
                resetBeforeTask(); 
                delNode(delItem);
            }
             modiChildsSize();
             document.getElementById("chkAllObj").checked = false ;
        } catch(ex){}
    }
    
    
    function onCheckAll(obj){
        var taskItems = document.getElementsByName("chkTaskItem");
        for (var i=0;i<taskItems.length;i++){
            taskItems[i].checked= obj.checked ;
        }
    }

    function onTaskNameChange(txtObj,rowIndex){      
    	/**
		var seleBeforeTaskObjs = document.getElementsByName("seleBeforeTask");
		if(seleBeforeTaskObjs == "[object]"){
			alert("");
			return;
		}
		for (var i=0;i<seleBeforeTaskObjs.length;i++){
			var selectValue = seleBeforeTaskObjs[i].value ;
			
			var optionIndex = getOptionIndex( seleBeforeTaskObjs[i].options,rowIndex);
			if (optionIndex!=-1)  seleBeforeTaskObjs[i].options.remove(optionIndex);     
			if (txtObj.value!="") {
				seleBeforeTaskObjs[i].options.add(new Option(txtObj.value,rowIndex),optionIndex) ;			
				seleBeforeTaskObjs[i].value = selectValue;
			}
		}   
		*/     
    }

    function getOptionIndex (optionsObj,objValue){
        for (var i=0 ;i<optionsObj.length;i++){
            if (optionsObj[i].value == objValue){
                return i;
            }
        }
        return -1;
    }
    
    //判断前置任务是否合法 by alan
    function beforeTask_check(obj) {
    	var oldindex = -1;
    	var oldobjs = document.getElementsByName('seleBeforeTask');
    	for(var i=1; i<=oldobjs.length; i++) {
    		if(oldobjs[i-1]==obj) {
    			oldindex = i;
    		}
    	}
    	if(oldindex==obj.value&&obj.value!=0) {
    		jQuery(obj).next().html(""); 
    		$(obj).val("0");
			/*if(readCookie("languageidweaver")==8){
				alert("Can't let hisself set his prefix task!");
			} 
			else if(readCookie("languageidweaver")==9){ 
				alert("不能把本身設置為前置任務!"); 
			}
			else {
				alert("不能把本身设置为前置任务!"); 
			}*/
			alert(SystemEnv.getHtmlNoteName(3434,readCookie("languageidweaver")));
    	}
    }

    //当前值任务改变的时候
    function onBeforeTaskChange(obj,selfIndex){
        var beforeTaskValue = obj.value;	
        if (beforeTaskValue==0) return false;
	
		
        //得到本身任务的对象
         var selfTaskBeginDateObj = document.getElementById("txtBeginDate_"+selfIndex);
         var selfTaskBeginDateSpanObj = document.getElementById("spanBeginDate_"+selfIndex);

         var selfTaskEndDateObj = document.getElementById("txtEndDate_"+selfIndex);
         var selfTaskEndDateSpanObj = document.getElementById("spanEndDate_"+selfIndex);

         var selfWorkLongObj = document.getElementById("txtWorkLong_"+selfIndex);

   
        //得到前置任何的对象
         var beforeTaskBeginDateObj = document.getElementById("txtBeginDate_"+beforeTaskValue);
         var beforeTaskBeginDateSpanObj = document.getElementById("spanBeginDate_"+beforeTaskValue);

         var beforeTaskEndDateObj = document.getElementById("txtEndDate_"+beforeTaskValue);
         var beforeTaskEndDateSpanObj = document.getElementById("spanEndDate_"+beforeTaskValue);

         var beforeWorkLongObj = document.getElementById("txtWorkLong_"+beforeTaskValue);

            //如果前置任务的结束时间大于本身任务的开始时间 那么修改本身任务的时间
         if (beforeTaskEndDateObj.value>selfTaskBeginDateObj.value||selfTaskBeginDateObj.value=='') {
            var newValue = getAddNewDateStr(beforeTaskEndDateObj.value,2);
            selfTaskBeginDateObj.value = newValue;
            selfTaskBeginDateSpanObj.innerHTML = newValue;
            if (selfWorkLongObj.value!="") {
                var newValue2 =getAddNewDateStr(selfTaskBeginDateObj.value,parseInt(selfWorkLongObj.value));
                selfTaskEndDateObj.value = newValue2;
                selfTaskEndDateSpanObj.innerHTML=newValue2;
            }
         }    
		 
		 	
		//判断前置任务选择的是不是其本身
		//得到得到本身任务的名称	
		//alert(beforeTaskValue+" "+selfIndex);
		if (beforeTaskValue==selfIndex)	{
			/*if(readCookie("languageidweaver")==8){
				alert("Can't let hisself set his prefix task!");
			} 
			else if(readCookie("languageidweaver")==9){ 
				alert("不能把本身設置為前置任務!"); 
			}
			else {
				alert("不能把本身设置为前置任务!"); 
			}	*/
			alert(SystemEnv.getHtmlNoteName(3434,readCookie("languageidweaver")));
			obj.value=0;	
			return false;
		}
   }
  //计算天数差的函数，通用
  //如果返回为-1 表示,sDate1比sDate2小
  function dateDiffForJava(sDate1,sDate2,sDate3,sDate4){  //sDate1和sDate2是2002-12-18格式
	
	var prjmanager  = document.getElementById("prjmanager"); 
	var passnoworktime  = document.getElementById("passnoworktime"); 
	
	
	if(sDate3==""){
		sDate3 = "09:00"
	}
	if(sDate4==""){
		sDate4 = "23:59"
	}
	var prjmanagervalue="";
	var passnoworktimevalue = "";
	
	if (prjmanager&&passnoworktime){ //编辑
		 prjmanagervalue = prjmanager.value; 
		 passnoworktimevalue = passnoworktime.value;
		 //alert(passnoworktimevalue)
		 if(passnoworktimevalue==1){
		 	passnoworktimevalue = true;
		 }else{
		 	passnoworktimevalue = false;
		 }	 
	} else{//新建
		try {
		prjmanagervalue=parent.document.getElementById("manager").value;
	 	passnoworktimevalue= parent.document.getElementById("passnoworktime").checked;
		}catch(e){
			prjmanagervalue ="-1";
			passnoworktimevalue = false;
		}
	}

	
	/**
	
	var manager="";
	var passnoworktime="";
	try{
		manager=parent.document.getElementById("manager").value;
	 	passnoworktime= parent.document.getElementById("passnoworktime").checked;
	}catch(e){
		manager=jQuery("#manger").val();
		passnoworktime=jQuery("#passnoworktime").val();
	}
	**/ 
	 
	
	

  if(!passnoworktimevalue){
   var aDate, oDate1, oDate2, iDays,odate3,odate4,tdate,otime1,otime2,oDatetime1, oDatetime2
    oDate1=new Date(sDate1);
	oDate2=new Date(sDate2);
	odate3=new Date(sDate3);
	odate4=new Date(sDate4);
	if(true || ""+oDate1.getFullYear()=="NaN"){
		aDate = sDate1.split("-")
		tdate = sDate3.split(":")
	    oDate1 = new Date(aDate[1] + '-' + aDate[2] + '-' + aDate[0])   //转换为12-18-2002格式
	    oDatetime1 = new Date(aDate[1] + '-' + aDate[2] + '-' + aDate[0]+" "+tdate[0]+":"+tdate[1]) 
	    aDate = sDate2.split("-")
	    tdate = sDate4.split(":")
	    oDate2 = new Date(aDate[1] + '-' + aDate[2] + '-' + aDate[0])
	    oDatetime2 = new Date(aDate[1] + '-' + aDate[2] + '-' + aDate[0]+" "+tdate[0]+":"+tdate[1])
    }
    if(oDate2-oDate1<0){
   		 iDays = -1 	//日期
    }else if(oDate2-oDate1==0){
    	if(sDate4<sDate3){
    		iDays = -2 //时间
    	}else{
    		iDays = (Math.abs(oDatetime1-oDatetime2) / 1000 / 60 / 60 /24).toFixed(2)     
    	}
    }else{
    	 iDays = (Math.abs(oDatetime1-oDatetime2) / 1000 / 60 / 60 /24).toFixed(2)
    }
    
  }else{
 	
  	 $.ajax({
           type: "post",
           url: "/proj/process/GetWorkDays.jsp",
           data:"begindate="+sDate1+"&begintime="+sDate3+"&enddate="+sDate2+"&endtime="+sDate4+"&manager="+prjmanagervalue,
           dataType: "text", 
           async:false,
           success:function(data){
           		iDays = data.trim();
           		
           }
       });
       
  }
  
   return iDays;
    
}
  
  

//判断input框中是否输入的是数字,包括小数点
  function ItemNum_KeyPress(obj){
     var event=getEvent();
	  tmpvalue = obj.value;
     var count = 0;
     var len = -1;
     len = tmpvalue.length; 
     for(i = 0; i < len; i++){
        if(tmpvalue.charAt(i) == "."){
        count++;     
        }
     }
     if(!((event.keyCode>=48 && event.keyCode<=57) || (event.keyCode==46 &&len>=1&& count == 0))) {           
    	 event.keyCode=0;         
      }
  }

  function upLevel(rowIndex){
		moveNodeUp(rowIndex);
		modiChildsSize();
		try{
			var obj=jQuery("#txtTaskName_"+rowIndex);
			//console.log("obj:"+obj);
			//console.log("obj width:"+obj.width());
			//obj.css('width','200px!important;');
		}catch(e){}
  }

  function downLevel(rowIndex){     
	  moveNodeDown(rowIndex);
	  modiChildsSize();
	  try{
			var obj=jQuery("#txtTaskName_"+rowIndex);
			//console.log("obj:"+obj);
			//console.log("obj width:"+obj.width());
			//obj.css('width','100px!important;');
		}catch(e){}
  }

 function onImgClick(obj,rowIndex){   
    if ($(obj).attr("imgState")=='show'){
        obj.src='/images/project_rank2_wev8.gif'
        obj.imgState='hidden'
        	showTRchilds(rowIndex,"hidden");
    } else {
        obj.src='/images/project_rank_wev8.gif'
        obj.imgState='show'
        	showTRchilds(rowIndex,"visible");
    }
 }
  
 function onHiddenImgClick(divObj,imgObj){
     if (imgObj.objStatus=="show"){
        divObj.style.display='none' ;       
        imgObj.src="/images/down_wev8.jpg";
		/*if(readCookie("languageidweaver")==8){
			imgObj.title="click then expand";
		}
		else if(readCookie("languageidweaver")==9){ 
			imgObj.title="點擊展開"; 
		}
		else {
			imgObj.title="点击展开";
		}	       
		*/
		imgObj.title = SystemEnv.getHtmlNoteName(3435,readCookie("languageidweaver"));
        imgObj.objStatus="hidden";
        if (divObj==divTaskList){
            divAddAndDel.style.display='none' ; 
        }
     } else {        
        divObj.style.display='' ;    
        imgObj.src="/images/up_wev8.jpg";
		/*if(readCookie("languageidweaver")==8){
			imgObj.title="click then hidden";
		}
		else if(readCookie("languageidweaver")==9){ 
			imgObj.title="點擊隱藏"; 
		}
		else {
			imgObj.title="点击隐藏";
		}        */
		imgObj.title = SystemEnv.getHtmlNoteName(3436,readCookie("languageidweaver"));
        imgObj.objStatus="show";
        if (divObj==divTaskList){

            divAddAndDel.style.display='' ; 
        }
     }
 }
   function  getXmlDocStr1(){      
        str = ptu.getXmlDocStr();
        document.all("areaLinkXml").value=  str ;    
   }


 function addSelManager(strId,strValue){ 
	 //修改项目人员时不做任何处理
  }
 
  function protectProjTemplet(event){ 
  	//if(!checkDataChange()) {//added by cyril on 2008-06-12 for TD:8828
  	        event=event||window.event; 
			/*if(readCookie("languageidweaver")==8){
				return event.returnValue="Project templet isn't save. if you left data will be lost ,are you srue?";
			}
			else if(readCookie("languageidweaver")==9)
			{
				return event.returnValue="項目模板還沒保存，如果離開，將會丟失數據，真的要離開嗎？";
			}
			else {
				return event.returnValue="项目模板还没保存，如果离开，将会丢失数据，真的要离开吗？";
				//return("当前页面的修改没有保存，确认退出？");
			} */
			return event.returnValue= SystemEnv.getHtmlNoteName(3437,readCookie("languageidweaver"));
	//	}        
  }

  function protectProj(e){ 
  	//if(!checkDataChange()) {//added by cyril on 2008-06-12 for TD:8828
		/*  if(readCookie("languageidweaver")==8){
			    event.returnValue="Project  isn't save. if you left data will be lost ,are you srue?";			
			} 
			else if(readCookie("languageidweaver")==9)
			{
				event.returnValue="項目還沒保存，如果離開，將會丟失數據，真的要離開嗎？";
			} 
			else {
				event.returnValue="项目还没保存，如果离开，将会丢失数据，真的要离开吗？";
			}
			*/
  	  e=e||event;
	  e.returnValue=SystemEnv.getHtmlNoteName(3438,readCookie("languageidweaver"));
    //}
   }
   
   /**
    * 检查字段是否为必填
    * @param {} fieldName
    * @return {Boolean}
    */
   function checkFields(fieldName){
        if(fieldName=="") return true;
        var fieldObj=$G(fieldName);
        var tagName=jQuery(fieldObj).attr("tagName");
        var fieldValue=fieldObj.value;
        var flag=true;
	   	 if(tagName=="INPUT"){
	   	 	var inputType=jQuery(fieldObj).attr("type");
	   	 	if(inputType=="checkbox"){
	   	 		if(!fieldObj.checked) flag=false;
	   	 	}else if(inputType=="text"||inputType=="hidden"){
	   	 		if(fieldValue=="") flag=false;
	   	 	}
	   	 }else if(tagName=="TEXTAREA"||tagName=="SELECT"){
	   	 	if(fieldValue=="") flag=false;
	  	 }
         if(!flag) alert(SystemEnv.getHtmlNoteName(3439,readCookie("languageidweaver")));   	
        return flag;
    } 