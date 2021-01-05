
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.mobile.webservices.workflow.WorkflowRequestTableRecord" %>
<%@ page import="weaver.mobile.webservices.workflow.WorkflowRequestTableField" %>
<%@ page import="weaver.general.* "%>
<%@ page import="java.util.* "%>
<%@ page import="weaver.mobile.webservices.workflow.WorkflowServiceUtil" %>
<%@ page import="weaver.hrm.*" %>


<script language="javascript">
  function ajaxinit(){
	             var ajax=false;
		         try {
		             ajax = new ActiveXObject("Msxml2.XMLHTTP");
		        } catch (e) {
		            try {
		                ajax = new ActiveXObject("Microsoft.XMLHTTP");
		            } catch (E) {
		                ajax = false;
		            }
		        }
	           if (!ajax && typeof XMLHttpRequest!='undefined') {
	                ajax = new XMLHttpRequest();
	            }
	            return ajax;
  }
  //需要改造ajax的方法
   function addRow<%=i %>(obj){
        var nodenum = document.getElementById("nodenum<%=i%>").value;
	    document.getElementById("nodenum<%=i%>").value = parseInt(nodenum)+1;
        var oTable=document.getElementById('detailInfo'+obj);
        var  htmlStr = "";
        var ajax=ajaxinit();
		ajax.open("GET", "/mobile/plugin/1/detailajax.jsp?groupId="+obj+"&derecorderindex="+nodenum+"&workflowid=<%=workflowid%>&nodeId=<%=nodeId%>&rowIndex="+nodenum+"&isEdits=<%=isEdits%>&isdisplay=<%=isdisplay%>&tableOrderId=<%=tableOrderId%>", false);
		ajax.setRequestHeader("Content-Type","application/x-www-form-urlencoded");
		ajax.send(null);
	    if (ajax.status == 200) {
			var htmlStr=ajax.responseText;
			jQuery(oTable).append(htmlStr);
		}
   }
   
   function deleteRow(obj){
       var flag = false;
	   var ids = document.getElementsByName('check_node'+obj);
	   for(i=0; i<ids.length; i++) {
		  if(ids[i].checked==true) {
			  flag = true;
			   break;
		  }
	   }
       if(flag) {
		  if(isdel()){
			  var isdeleteCount = 0;
             for(j=0; j<ids.length; j++) {
		        if(ids[j].checked==true) {
		           try{
		       
		           	if (jQuery(ids[j]).parent().parent().next().children("td").length == 1) {
		           		jQuery(ids[j]).parent().parent().next().remove();
		           	}
		              jQuery(ids[j]).parent().parent().remove();
                      isdeleteCount++;
		           }catch(e){
		           }
		           try{
		             var rowId= ids[j].value;
		             if(rowId != 'on'){
		                document.getElementById("deleteId"+obj).value += rowId+",";
		             }
		           }catch(e){}
		          j--;
		        }
	         }
	        //序号重现排序并将所有在行的所有字段序号都变动
			 sortDetail(obj,isdeleteCount);
			 //计算行列规则
	         calSum(obj);
        }
    }else{
        alert('<%=SystemEnv.getHtmlLabelName(22686,user.getLanguage())%>');
		return;
    }
   }

   function sortDetail(obj,isdeleteCount){
	    var nodenum =document.getElementById("nodenum"+obj).value;
	         var newRowNum = 0;
	         for(var k=0;k<nodenum;k++){
	             if(document.getElementById("detailRowNum"+obj+"_"+k)){ //当前行数据
	                 document.getElementById("detailRowNum"+obj+"_"+k).innerHTML = ""+(newRowNum+1);
					 //document.getElementById("detailRowNum"+obj+"_"+k).setAttribute("id","detailRowNum"+obj+"_"+newRowNum);
                      //将当前行的所有元素的序号都变更成新的序号
                         var  trObj =  document.getElementById("detailRowNum"+obj+"_"+k).parentNode;
						 //trobj事件变更
						var  trClickValue = trObj.getAttribute("onclick");
                         trClickValue = trClickValue.split(",")[0]+","+newRowNum+");"
						 trObj.setAttribute("onclick",trClickValue);
						 //显示tr,tdID修改
						 document.getElementById("trspace"+obj+"_"+k).setAttribute("id","trspace"+obj+"_"+newRowNum);
						 document.getElementById("tdspace"+obj+"_"+k).setAttribute("id","tdspace"+obj+"_"+newRowNum);
						  var tdElememtCount = 0;
						 for(var mx=0;mx<trObj.childNodes.length;mx++){
							    var tdObj = trObj.childNodes[mx];
								if(tdObj.nodeType == 1 && tdObj.nodeName == "TD"){
										if(tdElememtCount == 0){ //checkbox不需要变更
										}else if(tdElememtCount == 1){ //序号需要变更序号
											tdObj.setAttribute("id","detailRowNum"+obj+"_"+newRowNum);
										}else { //其他元素需要变更序号
											 var otherObjs =tdObj.childNodes;
											 for(var mw=0;mw<otherObjs.length;mw++){
												  var otherObj = otherObjs[mw];
												  if(otherObj.nodeType ==1 && otherObj.nodeName == 'A'){//点击事件需要变更序号
													  if(otherObj.getAttribute("id")&&otherObj.getAttribute("onclick")){
														  try{
														   var aid =   otherObj.getAttribute("id");
														   var ahref =otherObj.getAttribute("onclick");
														   var anewId = aid.split("_")[0]+"_"+newRowNum;
														   var anewhref = ahref.split("(")[0]+"("+ahref.split("(")[1].split(",")[0]+","+newRowNum+","+ahref.split("(")[1].split(",")[2]+","+ahref.split("(")[1].split(",")[3]+","+ahref.split("(")[1].split(",")[4];
														   otherObj.setAttribute("id",anewId);
														   otherObj.setAttribute("onclick",anewhref);
														  }catch(eother){}
													  }
												   }
												  if(otherObj.nodeType == 1 &&  otherObj.nodeName == 'INPUT'){ //input元素
													  if(otherObj.getAttribute("fieldType")){
														   if(otherObj.getAttribute("id")){
																otherObj.setAttribute("id",otherObj.getAttribute("id").split("_")[0]+"_"+newRowNum);
															 }
															 if(otherObj.getAttribute("name")){
																otherObj.setAttribute("name",otherObj.getAttribute("name").split("_")[0]+"_"+newRowNum);
															}
													  }else{
														   var inputValue =  otherObj.getAttribute("value");
														  inputValue = inputValue.split("_")[0]+"_"+newRowNum+"_"+inputValue.split("_")[2];
														  otherObj.setAttribute("value",inputValue);
													  }    
												  }
												  if(otherObj.nodeType == 1 &&  otherObj.nodeName == 'DIV'){ //DIV元素
													   var divId = otherObj.getAttribute("id");
													   if(divId != 'isedit'){ //展示数据的地方
															 var divNewId =  divId.split("_")[0]+"_"+newRowNum+"_"+divId.split("_")[2];
															 otherObj.setAttribute("id",divNewId);
															 try{
																for(var su=0;su<otherObj.childNodes.length;su++){
																	 var elementObj= otherObj.childNodes[su];
																	 if(elementObj.nodeType ==1 && elementObj.nodeName == 'SPAN'){
																			if(elementObj.getAttribute("id")){
																				elementObj.setAttribute("id",elementObj.getAttribute("id").split("_")[0]+"_"+newRowNum+"_"+elementObj.getAttribute("name").split("_")[2]);
																			  }
																			 if(elementObj.getAttribute("name")){
																					elementObj.setAttribute("name",elementObj.getAttribute("name").split("_")[0]+"_"+newRowNum+"_"+elementObj.getAttribute("name").split("_")[2]);
																			 }
																	 }
																	  if(elementObj.nodeType ==1 && elementObj.nodeName == 'INPUT'){
																			  if(elementObj.getAttribute("id")){
																					   elementObj.setAttribute("id",elementObj.getAttribute("id").split("_")[0]+"_"+newRowNum);
																			   }
																			  if(elementObj.getAttribute("name")){
																					elementObj.setAttribute("name",elementObj.getAttribute("name").split("_")[0]+"_"+newRowNum);
																			   }
																	  }
																}
															 }catch(e){}
													   }else if(divId == 'isedit'){ //编辑页面的数据变更
															 delEditEvent(otherObj,newRowNum);
													   }
												  }
											 }

										}
                                    
									tdElememtCount++;
								}
						 }
	                 newRowNum ++;
	             }else{
					 continue;
					 newRowNum --;
				 }
	         }
             
			 document.getElementById("nodenum"+obj).value = parseInt(nodenum) - isdeleteCount;





   }
   //删除的时候将编辑的元素Id进行变更 divObj 编辑DIV对象
    function delEditEvent(divObj,newRowNum){
	       var tableObjs =  divObj.childNodes;
		   for(var i=0;i<tableObjs.length;i++){
                var tableObj = tableObjs[i];
				//只读的情况
				if(tableObj.nodeType == 1 &&  tableObj.nodeName == 'INPUT'){
					     if(tableObj.getAttribute("id")){
                               tableObj.setAttribute("id",tableObj.getAttribute("id").split("_")[0]+"_"+newRowNum);
						}
					     if(tableObj.getAttribute("name")){
							 tableObj.setAttribute("name",tableObj.getAttribute("name").split("_")[0]+"_"+newRowNum);
						}
				}
				if(tableObj.nodeType == 1 &&  tableObj.nodeName == 'SPAN'){
                      if(tableObj.getAttribute("id")){
                               tableObj.setAttribute("id",tableObj.getAttribute("id").split("_")[0]+"_"+newRowNum+"_"+tableObj.getAttribute("name").split("_")[2]);
						}
					     if(tableObj.getAttribute("name")){
							 tableObj.setAttribute("name",tableObj.getAttribute("name").split("_")[0]+"_"+newRowNum+"_"+tableObj.getAttribute("name").split("_")[2]);
						}
				}
				
			   if(tableObj.nodeType == 1 &&  tableObj.nodeName == 'TABLE'){
					if(tableObjs[i].childNodes[0]){ //tbody
						if(tableObjs[i].childNodes[0].childNodes[0]){ //tr
                                var tdObjs = tableObjs[i].childNodes[0].childNodes[0].childNodes;
								var tdCount = 0;
							    for(var j=0;j<tableObjs[i].childNodes[0].childNodes[0].childNodes.length;j++){
								     var tdObj = tableObjs[i].childNodes[0].childNodes[0].childNodes[j];
									 if(tdObj.nodeType ==1 &&  tdObj.nodeName == 'TD'){
										  try{
											  if(tdObj.getAttribute("id")){ //如果是浏览框类型的td上包含了id
												   var tdIdSplits =  tdObj.getAttribute("id").split("_");
                                                   tdObj.setAttribute("id",tdIdSplits[0]+"_"+newRowNum+"_"+tdIdSplits[2]);
											  }
											  if(tdObj.getAttribute("onclick")){
												  var newonclick = "";
												  var splitValues = tdObj.getAttribute("onclick").split("&");
												  for(var si=0;si<splitValues.length;si++){
													    var splitValue=splitValues[si];
														if(splitValue.indexOf("=")>=0){
															var sequalsValue = splitValue.split("=");
															var newReturnValue ="";
															for(var se=0;se<sequalsValue.length;se++){
																 var  sequalsVal =  sequalsValue[se];
                                                                 if(sequalsVal.indexOf("_")>=0){
																	  var splitRealV=sequalsVal.split("_");
																	  if(splitRealV.length == 2){
																		   newReturnValue += splitRealV[0]+"_"+newRowNum;
																	  }else if(splitRealV.length == 3){
																		   newReturnValue += splitRealV[0]+"_"+newRowNum+"_"+splitRealV[2];
																	  } 
																 }else{
																	 if(se == 0){
																		  newReturnValue += sequalsVal +"=";
																	 }else{
																		   newReturnValue += sequalsVal;
																	 }
                                                                    
																 }
															}
															if(si==(splitValues.length-1)){
                                                                  newonclick += newReturnValue;
															}else{
																 newonclick += newReturnValue + "&";
															}
															
														}else{
														    newonclick +=splitValue+"&";
														}
														
													    
												  }
                                                  tdObj.setAttribute("onclick",newonclick);
											  }
										  }catch(e){}
										   var elementObjs =   tdObj.childNodes;
										   for(var k=0;k<elementObjs.length;k++){
											     var elementObj = elementObjs[k];
												 if(elementObj.nodeType == 1 && elementObj.nodeName == 'INPUT'){ //input 元素
													 if(tdCount == 0){ //非必填的情况
														 var oldId = "";
														 var newChangeId = "";
													     if(elementObj.getAttribute("id")){ //id的变更
															  var idValue = elementObj.getAttribute("id");
															   oldId = idValue;
															   if(idValue.indexOf("_")>=0){
																   var splitValues = idValue.split("_");
																   var  newId="";
																   for(var s=0;s<splitValues.length;s++){
																	      
																		  if(s==(splitValues.length -1)){
																			    newId +=newRowNum;
																		  }else{
																			   newId += splitValues[s] +"_";
																		  }
																   }
                                                                   newChangeId = newId; 
                                                                   elementObj.setAttribute("id",newId);
															   } 
														}
														if(elementObj.getAttribute("name")){ //name的变更
                                                            var  nameValue = elementObj.getAttribute("name");
															if(nameValue.indexOf("_")>=0){
																   var  newName ="";
																   var splitnames = nameValue.split("_");
																   for(s=0;s<splitnames.length;s++){
																	   if(s == (splitnames.length -1)){
																		      newName += newRowNum;
																	   }else{
																		     newName += splitnames[s] + "_";
																	   }
																   }
                                                                 elementObj.setAttribute("name",newName);
															} 
														}
														if(elementObj.getAttribute("onchange")){
															var reg=new RegExp(oldId,"gmi");
                                                             elementObj.setAttribute("onchange",
																 elementObj.getAttribute("onchange").replace(reg,newChangeId));
														}
								
														if(elementObj.getAttribute("onkeypress")){
															var oldMoney = oldId; 
															var newMoney = newChangeId;
															if(oldId.indexOf("lable")>=0){
																  oldMoney = oldId.replace(/_lable/g,'');
															}
														    if(newChangeId.indexOf("lable")>=0){
																 newMoney = newChangeId.replace(/_lable/g,'');
															}
                                                             var reg=new RegExp(oldMoney,"gmi");
                                                             elementObj.setAttribute("onkeypress",
																 elementObj.getAttribute("onkeypress").replace(reg,newMoney));
														}

														if(elementObj.getAttribute("onblur")){
															if(elementObj.getAttribute("onblur").indexOf("numberToFormat")>=0){
																  var reg=new RegExp(oldId.replace(/field_lable/g,''),"gmi");
																   elementObj.setAttribute("onblur",
																	 elementObj.getAttribute("onblur").replace(reg,newChangeId.replace(/field_lable/g,'')));
															}else{
																 var reg=new RegExp(oldId,"gmi");
																 elementObj.setAttribute("onblur",
																	 elementObj.getAttribute("onblur").replace(reg,newChangeId));
															}
														}

													   if(elementObj.getAttribute("onfocus")){
														   if(elementObj.getAttribute("onfocus").indexOf("FormatToNumber")>=0){
															    var reg=new RegExp(oldId.replace(/field_lable/g,''),"gmi");
																   elementObj.setAttribute("onfocus",
																	 elementObj.getAttribute("onfocus").replace(reg,newChangeId.replace(/field_lable/g,'')));
														   }else{
															   var reg=new RegExp(oldId,"gmi");
                                                               elementObj.setAttribute("onfocus",
																     elementObj.getAttribute("onfocus").replace(reg,newChangeId));
														   }
                                                            
														}

													 }else{ //验证必填的情况
														 if(elementObj.getAttribute("id") && elementObj.getAttribute("id") == 'ismandfield'){ //id的变更
															     var elementValue = elementObj.getAttribute("value");
																  if(elementValue.indexOf("_")>=0){
																     var  newValue = elementValue.split("_")[0]+"_"+newRowNum;
                                                                     elementObj.setAttribute("value",newValue);
															      }
														 }
													 }
												 }

												 if(elementObj.nodeType == 1 && elementObj.nodeName == 'TEXTAREA'){
													   if(elementObj.getAttribute("id")){
                                                            elementObj.setAttribute("id",elementObj.getAttribute("id").split("_")[0]+"_"+newRowNum);
													   }
													   if(elementObj.getAttribute("name")){
														     elementObj.setAttribute("name",elementObj.getAttribute("name").split("_")[0]+"_"+newRowNum);
													   }
												 }

												  if(elementObj.nodeType == 1 && elementObj.nodeName == 'SELECT'){
													   if(elementObj.getAttribute("id")){
                                                            elementObj.setAttribute("id",elementObj.getAttribute("id").split("_")[0]+"_"+newRowNum);
													   }
													   if(elementObj.getAttribute("name")){
														     elementObj.setAttribute("name",elementObj.getAttribute("name").split("_")[0]+"_"+newRowNum);
													   }
												 }


												  if(elementObj.nodeType == 1 && elementObj.nodeName == 'SPAN'){ //input 元素
													 if(tdCount == 0){ //非必填的情况
													     
													 }else{ //验证必填的情况
														 if(elementObj.getAttribute("id")){ //id的变更
															     var elementValue = elementObj.getAttribute("id");
																  if(elementValue.indexOf("_")>=0){
																     var  newValue = elementValue.split("_")[0]+"_"+newRowNum+"_"+elementValue.split("_")[2];
                                                                     elementObj.setAttribute("id",newValue);
															      }
														 }
													 }
												 }
										   }
                                          tdCount++; 
									 }
				                }
						}
					}
			   }

		   }
	}
   
   function isdel(){
	  var str = "<%=SystemEnv.getHtmlLabelName(15097,user.getLanguage())%>";
      if(!confirm(str)){
            return false;
      }
       return true;
   }
</script>

