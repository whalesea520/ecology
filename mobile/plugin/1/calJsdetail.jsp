
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.mobile.webservices.workflow.WorkflowRequestTableRecord" %>
<%@ page import="weaver.mobile.webservices.workflow.WorkflowRequestTableField" %>
<%@ page import="weaver.workflow.datainput.DynamicDataInput"%>
<%@ page import="weaver.general.* "%>
<%@ page import="java.util.* "%>
<script language="javascript">
function $G(identity, _document) {
	return $GetEle(identity, _document);
}
/**
 * 根据标识（name或者id）获取元素，主要用于解决系统中很多元素没有id属性，
 * 却在js中使用document.getElementById(name)来获取元素的问题。
 * @param identity name或者id
 * @return 元素
 */
function $GetEle(identity, _document) {
	var rtnEle = null;
	if (_document == undefined || _document == null) _document = document;
	
	rtnEle = _document.getElementById(identity);
	if (rtnEle == undefined || rtnEle == null) {
		rtnEle = _document.getElementsByName(identity);
		if (rtnEle.length > 0) rtnEle = rtnEle[0];
		else rtnEle = null;
	}
	return rtnEle;
}

function parse_Float(i){
	try{
		i = parseFloat(i);
		if((i+"")==("NaN")){
			return 0;
		}else{
			return i;
		}
	}catch(e){
		return 0;
	}
}

function toPrecision(aNumber,precision){
	var temp1 = Math.pow(10,precision);
	var temp2 = new Number(aNumber);
    //QC79136 中修改
	var returnVal = isNaN(Math.round(temp1*temp2) /temp1)?0:Math.round(temp1*temp2) /temp1;
	try{
		if(String(returnVal).indexOf("e")>=0)return returnVal;
	}catch(e){}
	var valInt = (returnVal.toString().split(".")[1]+"").length;
	if(aNumber == 0){
		return  "";
	}
	if(valInt != precision){
	    var lengInt = precision-valInt;
		//判断添加小数位0的个数
		if(lengInt == 1){
			returnVal += "0";
		}else if(lengInt == 2){
			returnVal += "00";
		}else if(lengInt == 3){
			returnVal += "000";
		}else if(lengInt < 0){
			if(precision == 1){
				returnVal += ".0";
			}else if(precision == 2){
				returnVal += ".00";
			}else if(precision == 3){
				returnVal += ".000";
			}else if(precision == 4){
				returnVal += ".0000";
			}		
		}		
	}
	return  returnVal;		
}

function changeToThousandsVal(sourcevalue){
	sourcevalue = sourcevalue +"";
	if(null != sourcevalue && 0 != sourcevalue){
     if(sourcevalue.indexOf(".")<0)
        re = /(\d{1,3})(?=(\d{3})+($))/g;
    else
        re = /(\d{1,3})(?=(\d{3})+(\.))/g;
		return sourcevalue.replace(re,"$1,");
	}else{
		return sourcevalue;
	}
}



  function calSumPrice(){
     var temv1;
     var datalength = 2;
     var evt = getEvent();
<%
    String temStr = "";
    for(int m=0; m<rowCalAry.size(); m++){
        temStr = "";
		String calExp = (String)rowCalAry.get(m);
        ArrayList calExpList=DynamicDataInput.FormatString(calExp);
%>
        try{
            var nowobj=(evt.srcElement ? evt.srcElement : evt.target).name.toString();
            var i=0;
			var testDataValueType = (evt.srcElement ? evt.srcElement : evt.target).getAttribute("datavaluetype");
			if(testDataValueType && testDataValueType == 4){
				 if(nowobj.indexOf('_')>-1){
				   i=nowobj.substr(nowobj.indexOf('_')+1);
				   if(i.indexOf('_')>-1)i=i.substr(i.indexOf('_')+1);
				}
			}else{
				if(nowobj.indexOf('_')>-1){
				   i=nowobj.substr(nowobj.indexOf('_')+1);
				   if(i.indexOf('_')>-1)
						i=i.substr(0,i.indexOf('_'));
				}
			}
        <%
            for(int j=0;j<calExpList.size();j++){
            calExp=(String)calExpList.get(j);
			String targetStr ="";
       %>
       try {
       <%
            if(calExp.indexOf("innerHTML")>0){
		        out.println("if(i.indexOf('_')>=0){i=parseInt(i.substring(0,i.indexOf('_')));}");
				targetStr=calExp.substring(0,calExp.indexOf("innerHTML")-7)+"_span\")";
				out.println("if("+targetStr+"){");
            if (calExp.indexOf("=") != calExp.length()-1) {
            	 out.println("try{"); 
            	 out.println(calExp.replace("span","_span")+"; "); 
				 out.println(calExp.replace("span","_span_d")+"; ");
				 out.println("try{ ");
					 String isshowDiv= "";
					 if(targetStr.indexOf("_")>=0){
						isshowDiv =targetStr.substring(0,targetStr.indexOf("_")).replace("field","")+"\"+i)";
					 }
				    out.println("if("+isshowDiv+"){");
				       out.println("document.getElementById("+isshowDiv+".value).innerHTML="+targetStr+".innerHTML");
                    out.println("}");
				 out.println("}catch(ev){} ");
            	 try{
             		 if(calExp.indexOf("=")>=0){
             			 String[] calSplitSign=calExp.split("=");
             			 String rightequalsmark = calSplitSign[0].replace(".innerHTML","");
             			 String leftequalsmark = calSplitSign[1].replace(".replace(/,/g,\"\"))", "").replace("parse_Float(", "").replace(".value", ""); 
             			 if(leftequalsmark.indexOf("/")>=0){
             				  String leftdivide  =leftequalsmark.split("/")[0];
             				  String rightdivide =leftequalsmark.split("/")[1];
             				  String inputObj = rightequalsmark.replace("+\"span\")",")");
             				  out.println(" if("+rightequalsmark+".innerHTML == \"Infinity\" ||  "+rightequalsmark+".innerHTML == \"-Infinity\" || "+rightequalsmark+".innerHTML == \"NaN\"){");
             				  out.println("if("+inputObj+".viewtype == 1){"); //必填
             				  out.println(rightequalsmark+".innerHTML=\"<img src='/images/BacoError_wev8.gif' align=absmiddle>\";");
             				  out.println("}else{");
             				  out.println(rightequalsmark+".innerHTML='';");
             				  out.println("}");
             				  out.println(inputObj+".value='';");
             				  out.println("return;");
             				  out.println("}");
             			 }
             		 } 
             	  }catch(Exception e){}
             	  out.println("}catch(ex){");
             	  out.println("}");
            }
            out.println("}");
			
			out.println("if("+calExp.substring(0,calExp.indexOf("innerHTML")-9)+").getAttribute('datetype')=='int' && "+calExp.substring(0,calExp.indexOf("innerHTML")-9)+").getAttribute('datavaluetype')!='5'){ ") ;
			out.println(calExp.substring(0,calExp.indexOf("=")).replace("span","_span")+"=toPrecision("+calExp.substring(0,calExp.indexOf("innerHTML")-9)+").value,0);");
			out.println(calExp.substring(0,calExp.indexOf("=")).replace("span","_span_d")+"=toPrecision("+calExp.substring(0,calExp.indexOf("innerHTML")-9)+").value,0);");
			out.println("}else if("+calExp.substring(0,calExp.indexOf("innerHTML")-9)+").getAttribute('datetype')!='int' && "+calExp.substring(0,calExp.indexOf("innerHTML")-9)+").getAttribute('datavaluetype')=='5'){");
               out.println("if("+targetStr+"){");
			     out.println(targetStr+".innerHTML=changeToThousandsVal("+calExp.substring(0,calExp.indexOf("innerHTML")-9)+").value)+'';");
				  out.println(targetStr.replace("_span","_span_d")+".innerHTML=changeToThousandsVal("+calExp.substring(0,calExp.indexOf("innerHTML")-9)+").value)+'';");
			   out.println("try{ ");
			   String isshowDiv= "";
			     if(targetStr.indexOf("_")>=0){
				   isshowDiv =targetStr.substring(0,targetStr.indexOf("_")).replace("field","")+"\"+i)";
			     }
				out.println("if("+isshowDiv+"){");
			    out.println("document.getElementById("+isshowDiv+".value).innerHTML=changeToThousandsVal("+calExp.substring(0,calExp.indexOf("innerHTML")-9)+").value)+'';");
               out.println("}");
			   out.println("}catch(ev){} ");
               out.println("}");
                 String targetValue = targetStr.substring(0,targetStr.lastIndexOf("+"))+")";
                 out.println("if("+targetValue+"){");
			     out.println(targetValue+".value=changeToThousandsVal("+calExp.substring(0,calExp.indexOf("innerHTML")-9)+").value)+'';");
                out.println("}");
			 out.println("}else if("+calExp.substring(0,calExp.indexOf("innerHTML")-9)+").getAttribute('datetype')!='int' && "+calExp.substring(0,calExp.indexOf("innerHTML")-9)+").getAttribute('datavaluetype')=='4'){");
             out.println("try{ ");
					 if(targetStr.indexOf("_")>=0){
						isshowDiv =targetStr.substring(0,targetStr.indexOf("_")).replace("field","")+"\"+i)";
					 }
				    out.println("if("+isshowDiv+"){");
				        out.println("var moneyFormat ="+targetStr+".innerHTML ");
					   out.println("if(moneyFormat == '' || moneyFormat == 0 || moneyFormat == '0'){");
					    out.println("moneyFormat= '0.00'");
					   out.println("}else{");
					     out.println("moneyFormat= (milfloatFormat(toPrecision("+targetStr+".innerHTML,datalength))); "); 
					   out.println("}");
				       out.println("document.getElementById("+isshowDiv+".value).innerHTML=numberChangeToChinese("+targetStr+".innerHTML)+'('+moneyFormat+')';");
                       out.println(targetStr.replace("_span","_span_d")+".innerHTML=numberChangeToChinese("+targetStr+".innerHTML)+'('+moneyFormat+')';");
					out.println("}");
				 out.println("}catch(ev){} ");
				  String  resultNum = calExp.substring(0,calExp.indexOf("innerHTML")-9).substring(calExp.indexOf("field")+5)+"+\"_d";
            out.println("try{");
              out.println("if("+calExp.substring(0,calExp.indexOf("innerHTML")-9)+"+\"_d\")){");
                  out.println(" var fieldtype="+calExp.substring(0,calExp.indexOf("innerHTML")-9)+"+\"_d\").getAttribute('datavaluetype');");
                    out.println("  if(fieldtype == 4){");
                             out.println(" document.getElementById(\"field_lable"+resultNum+"\").value = toPrecision("+calExp.substring(0,calExp.indexOf("innerHTML")-9)+"+\"_d\").value,datalength);");
                           out.println(" numberToFormat(\""+resultNum+"\");");
			           out.println("document.getElementById(\"field_lable"+resultNum+"\").onchange()");
                     out.println("}");
                   out.println("}");
                out.println("}catch(e){");
		        out.println("}");
			 out.println("}else{");
                out.println("if("+targetStr+"){");
                 out.println(targetStr+".innerHTML=toPrecision("+calExp.substring(0,calExp.indexOf("innerHTML")-9)+").value,datalength);");
			   out.println(targetStr.replace("_span","_span_d")+".innerHTML=toPrecision("+calExp.substring(0,calExp.indexOf("innerHTML")-9)+").value,datalength);");
			  out.println("try{ ");
			  if(targetStr.indexOf("_")>=0){
						isshowDiv =targetStr.substring(0,targetStr.indexOf("_")).replace("field","")+"\"+i)";
			  }
			  out.println("if("+isshowDiv+"){");
			  out.println("document.getElementById("+isshowDiv+".value).innerHTML=toPrecision("+calExp.substring(0,calExp.indexOf("innerHTML")-9)+").value,datalength);");
              out.println("}");
		     out.println("}catch(ev){} ");
            out.println("}");
            out.println("}");
            }else{
              if(calExp.indexOf("value")>0){
                  targetStr=calExp.substring(0,calExp.indexOf("value")-1);
                  out.println("if("+targetStr+"){");
                  out.println(" datalength = "+targetStr+".getAttribute('datalength');");
                  if (calExp.indexOf("=") != calExp.length()-1) {
            	      out.println(calExp+"; ") ;
                  }
			     out.println("if("+calExp.substring(0,calExp.indexOf("value")-1)+".datatype=='int'){ "+calExp.substring(0,calExp.indexOf("="))+"=toPrecision("+calExp.substring(0,calExp.indexOf("="))+",0);"
				  +"}else{ "+calExp.substring(0,calExp.indexOf("="))+"=toPrecision("+calExp.substring(0,calExp.indexOf("="))+",datalength);}}");
				 out.println(calExp.substring(0,calExp.indexOf("value")-2)+"+\"_d\").value=toPrecision("+calExp.substring(0,calExp.indexOf("="))+",datalength)");
				 out.println(calExp.substring(0,calExp.indexOf("value")-2)+"+\"_d\").onchange();");
                }
             }
            %>
                 }catch(e){}
            <%
                }
	        %>
       }
       catch(e){}
<%
    }
%>
}

function calMainField(obj){
    var rows=0;
    var datalength = 2;
    var rowindex =0;
    <%for(int m=0;m<wdtiCount;m++){%>
         var temprow=0;
         if(document.getElementById('nodenum<%=m%>')) temprow=parseInt(document.getElementById('nodenum<%=m%>').value);
         if(temprow>rows) rows=temprow;
    <%}%>
    if(rowindex<rows)
        rowindex=rows;
	<%
		for(int m=0;m<mainCalAry.size();m++){
			String str2 =  mainCalAry.get(m).toString();
		    int idx = str2.indexOf("=");
			String str3 = str2.substring(0,idx);
			str3 = str3.substring(str3.indexOf("_")+1);
			String str4 = str2.substring(idx);
			str4 = str4.substring(str4.indexOf("_")+1);
	%>
               var sum=0;
               var temStr;
                for(i=0; i<rowindex; i++){

                    try{
                        temStr=$GetEle("field<%=str4%>_"+i).value;
                        temStr = temStr.replace(/,/g,"");
                        if(temStr+""!=""){
                            sum+=temStr*1;
                        }
                    }catch(e){}
                }
                if($GetEle("field<%=str3%>")){
                      datalength = $GetEle("field<%=str3%>").getAttribute("datalength");
                  if($GetEle("field<%=str3%>").getAttribute("datatype")=="int")
                	  document.getElementById("field<%=str3%>").value=toPrecision(sum,0);
                  else
                	  document.getElementById("field<%=str3%>").value=toPrecision(sum,datalength);
                }
                if($GetEle("field<%=str3%>")){
					if(document.getElementById("field<%=str3%>")&&document.getElementById("field<%=str3%>").getAttribute("datatype")=="text"){
						document.getElementById("field<%=str3%>span").innerHTML="";
					}else{
						if(document.getElementById("field<%=str3%>").getAttribute("datatype") == "int"){
						   if(document.getElementById("field<%=str3%>span")){
						        document.getElementById("field<%=str3%>span").innerHTML=toPrecision(sum,0);
						   }
						   if(document.getElementById("field<%=str3%>")){
						         document.getElementById("field<%=str3%>").value=toPrecision(sum,0);
						   }
						}else if(document.getElementById("field<%=str3%>").getAttribute("datatype")=="float" && document.getElementById("field<%=str3%>").getAttribute("datavaluetype")== "5"){
							if(document.getElementById("field<%=str3%>span")){
							    document.getElementById("field<%=str3%>span").innerHTML=changeToThousandsVal(toPrecision(sum,datalength)); 
							}
							if(document.getElementById("field<%=str3%>")){
							    document.getElementById("field<%=str3%>").value=changeToThousandsVal(toPrecision(sum,datalength)); 
							}
						}else{
						     if(document.getElementById("field<%=str3%>span")){
						         document.getElementById("field<%=str3%>span").innerHTML=toPrecision(sum,datalength);
						     }
							
							try{
								 if(document.getElementById("field<%=str3%>").getAttribute("datavaluetype")){
								       var filedtype=document.getElementById("field<%=str3%>").getAttribute("datavaluetype");
								        if(filedtype == 4){
								            document.getElementById("field_lable<%=str3%>").value=toPrecision(sum,datalength);
								            try{
								                numberToFormat(<%=str3%>);
								             }catch(e){
								             }
								       }
								  }
							}catch(e){}
						}
					}

                }
	     <%}%>
 }
 
 function calSum(obj){
    calSumPrice();
    var rows=0;
    <%for(int m=0;m<wdtiCount;m++){%>
    var temprow=0;
    var rowindex = 0;
    if(document.getElementById('nodenum<%=m%>')) temprow=parseInt(document.getElementById('nodenum<%=m%>').value);
    if(temprow>rows) rows=temprow;
    <%}%>
    if(rowindex<rows)
        rowindex=rows;
    var sum=0;
    var temStr;
<%
    for(int m=0; m<colCalAry.size(); m++){
		String str = colCalAry.get(m).toString();
		str = str.substring(str.indexOf("_")+1);
		if("0".equals(isBill)){
			 RecordSet.executeSql("select fielddbtype from workflow_formdict where id=" + str);
        }else{
        	 RecordSet.executeSql("select fielddbtype from workflow_billfield where id=" + str);
        }
		int decimaldigits_t =2;
    	if("oracle".equals(RecordSet.getDBType())){
    		 if(RecordSet.next()){
    	        	String fielddbtypeStr=RecordSet.getString("fielddbtype");
    	        	if(fielddbtypeStr.indexOf("number")>=0){
    	        		int digitsIndex = fielddbtypeStr.indexOf(",");
        				if(digitsIndex > -1){
        					decimaldigits_t = Util.getIntValue(fielddbtypeStr.substring(digitsIndex+1, fielddbtypeStr.length()-1), 2);
        				}else{
        					decimaldigits_t = 2;
        				}
    	        	}else{
    	        		if(fielddbtypeStr.equals("integer")){
    	        			decimaldigits_t = 0;
    	        		}
    	        	}
    	        }
    	}else{
    		 if(RecordSet.next()){
 	        	String fielddbtypeStr=RecordSet.getString("fielddbtype");
 	        	if(fielddbtypeStr.indexOf("decimal")>=0){
 	        		int digitsIndex = fielddbtypeStr.indexOf(",");
     				if(digitsIndex > -1){
     					decimaldigits_t = Util.getIntValue(fielddbtypeStr.substring(digitsIndex+1, fielddbtypeStr.length()-1), 2);
     				}else{
     					decimaldigits_t = 2;
     				}
 	        	}else{
 	        		if("int".equals(fielddbtypeStr)){
 	        			decimaldigits_t = 0;
 	        		}
 	        	}
 	        }
    	}
		//String defaultValue = "0";
	   // if(null != summap.get(str)&&!"".equals((String)summap.get(str))){
		//	  defaultValue = (String)summap.get(str);
		//}
%>
             sum=0;
            for(i=0; i<rowindex; i++){

                try{
                    temStr=document.getElementById("field<%=str%>_"+i).value;
                    temStr = temStr.replace(/,/g,"");
                    if(temStr+""!=""){
                        sum+=temStr*1;
                    }
                }catch(e){;}
            }
            
        var decimalNumber = <%=decimaldigits_t%>;
        
        if(document.getElementById("sum<%=str%>")!=null){
        	document.getElementById("sum<%=str%>").innerHTML=toPrecision(sum,decimalNumber)+" ";
        }
        if(document.getElementById("sumvalue<%=str%>")!=null){
        	document.getElementById("sumvalue<%=str%>").value=toPrecision(sum,decimalNumber);
        }
<%
    }
%>
	calMainField(obj);
}
 


function getEvent() {
	if (window.ActiveXObject) {
		return window.event;// 如果是ie
	}
	func = getEvent.caller;
	while (func != null) {
		var arg0 = func.arguments[0];
		if (arg0) {
			if ((arg0.constructor == Event || arg0.constructor == MouseEvent)
					|| (typeof (arg0) == "object" && arg0.preventDefault && arg0.stopPropagation)) {
				return arg0;
			}
		}
		func = func.caller;
	}
	return null;
}

window.onload = function (){
    var detailrow = 0; 
     <%
      for(int u=0;u<colCalAry.size();u++){
    	  String fieldStr =(String)colCalAry.get(u);
		  String  defaultValue = "0";
    	  fieldStr =fieldStr.replaceAll("detailfield_","");
		  if(null != summap.get(fieldStr)&&!"".equals((String)summap.get(fieldStr))){
			  defaultValue = (String)summap.get(fieldStr);
		   }
    	 for(int o=0;o<wdtiCount;o++){
     %>
       try{
           if(document.getElementById("nodenum<%=o%>")){
               detailrow=document.getElementById("nodenum<%=o%>").value;
               var sumvalue = <%=defaultValue%>;
               var datalength = 2;
               //var datatype = "float";
              // var datavaluetype = 0;
               //for(i=0;i<detailrow;i++){
                    //var fieldObj = document.getElementById("field<%=fieldStr%>_"+i);
                   //if(fieldObj){
                        //datalength=fieldObj.getAttribute("datalength");
                       // datatype=fieldObj.getAttribute("datatype");
                        //datavaluetype=fieldObj.getAttribute("datavaluetype");
                       // var  val = new Number(fieldObj.value.replace(/,/g, ""));
                       // sumvalue += val;
                  // }
             //  }
              // if(datavaluetype == 5){
                  // document.getElementById("sum<%=fieldStr%>").innerHTML = changeToThousandsVal(toPrecision(sumvalue,datalength));
             //  }else{
                   document.getElementById("sum<%=fieldStr%>").innerHTML = toPrecision(sumvalue,datalength);
              // }
            }
        }catch(e){}
     <%}}%>
}

	 //验证是否选择为必须新增的
function  needAddRow(){
	var messageInfo = "";
    var tableCount = <%=wdtiCount%>;
	for(var i=0;i<tableCount;i++){
		try{
			var count=0;
		   $(".isneed_"+i).each(function() {
			   if(this.getAttribute("class")){
				    count = 1;
			   }
	      });
		  if(count == 0){
			  var  needAddRowObj = jQuery("input[id='"+("needAddRow"+i)+"']");
			  if(jQuery("input[id='"+("needAddRow"+i)+"']").val() == "1"){
				  messageInfo = "必须填写第"+(i+1)+"个明细表数据，请填写";
				  break;
			  }
		  }
		}catch(e){
		   continue;
		}
	}
    return messageInfo;
}

</script>

