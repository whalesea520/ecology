<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.workflow.datainput.DynamicDataInput"%>
<%@ page import="weaver.general.* "%>
<%@ page import="java.util.* "%>
<%
//行列规则计算
RecordSet calReocrdSet=new RecordSet();
ArrayList colCalAry = new ArrayList(); //合计
ArrayList rowCalAry = new ArrayList(); //行规则
ArrayList mainCalAry = new ArrayList(); //列规则
String rowCalItemStr1="";
String colCalItemStr1="";
String mainCalStr1="";
calReocrdSet.execute("select * from workflow_formdetailinfo where formid="+formId);
while(calReocrdSet.next()){
	rowCalItemStr1 = Util.null2String(calReocrdSet.getString("rowCalStr"));
	colCalItemStr1 = Util.null2String(calReocrdSet.getString("colCalStr"));
	mainCalStr1 = Util.null2String(calReocrdSet.getString("mainCalStr"));
}
StringTokenizer stk2 = new StringTokenizer(colCalItemStr1,";"); //列规则
while(stk2.hasMoreTokens()){
	colCalAry.add(stk2.nextToken());
}
stk2 = new StringTokenizer(rowCalItemStr1,";");//行规则
while(stk2.hasMoreTokens()){
	rowCalAry.add(stk2.nextToken(";"));
}
stk2 = new StringTokenizer(mainCalStr1,";");
while(stk2.hasMoreTokens()){
	mainCalAry.add(stk2.nextToken(";"));
}
%>
<script>
jQuery(document).ready(function(){
	jQuery("input[type='hidden'][name^=nodenum]").each(function(){
		var groupid=jQuery(this).attr("name").replace("nodenum","");
		calSum(groupid);
	});
});


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

function getFieldSumValue(fieldid){
	var sumValue=0;
	try{
		var fieldInputObj = jQuery("input[name^='field"+fieldid+"_']");
		if(fieldInputObj.size() > 0){
			var oTable = fieldInputObj.first().closest("table[name^='oTable']");
			var oTableNameObj = oTable.attr("name");
			var groupindex =0;
			if(oTableNameObj!=null && oTableNameObj!=undefined){
				 groupindex =  oTableNameObj.replace("oTable","");
			}
			var rownum = $("input[name='nodenum"+groupindex+"']").val();
			for(var i=0; i<rownum; i++){
				try{
					var tempVal = jQuery("[name='field"+fieldid+"_"+i+"']").val();
					if(!!tempVal){
						tempVal = tempVal.replace(/,/g,"");
						sumValue += tempVal*1;
					}
				}catch(ev){}
			}
		}else{
		    return null;
		}
	}catch(e){}
	return sumValue;
}

function calSum(obj){
	calSumPrice();		//行规则计算
	<%	
		for(int m=0; m<colCalAry.size(); m++){
			String str = colCalAry.get(m).toString();
			str = str.substring(str.indexOf("_")+1);		//合计字段ID
			int decimaldigits_t=workflowServiceUtil.getDecimaldigitsById(isBill,str);
	%>
			if(document.getElementById("sum<%=str%>")!=null){
				var sum=getFieldSumValue("<%=str %>");
				if(sum!=null){
        		  document.getElementById("sum<%=str%>").innerHTML=toPrecision(sum,"<%=decimaldigits_t %>")+" ";
				}
        	}
	<%
		}
	%>
	calMainField(obj);		//列规则计算
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
			if(testDataValueType && testDataValueType == 4)
				 nowobj = nowobj.replace("field_lable", "field");
			if(nowobj.indexOf('_')>-1){
			   i=nowobj.substr(nowobj.indexOf('_')+1);
			   if(i.indexOf('_')>-1)
					i=i.substr(0,i.indexOf('_'));
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
					   out.println("if(jQuery('span[id='+"+targetStr+".getAttribute(\"id\")+']').length>1){");
					        out.println("jQuery('span[id='+"+targetStr+".getAttribute(\"id\")+']')[0].setAttribute('id','"+targetStr+".getAttribute(\"id\")_sd');");
                       out.println("}");
					out.println("}");
				out.println("if("+targetStr+"){");
            if (calExp.indexOf("=") != calExp.length()-1) {
            	 out.println("try{"); 
            	 out.println(calExp.replace("span","_span")+"; "); 
				 out.println(calExp.replace("span","_span_d")+"; ");
				 out.println("try{ ");
					 String isshowDiv_Fieldid= "";
					 if(targetStr.indexOf("_")>=0){
						 isshowDiv_Fieldid=targetStr.substring(0,targetStr.indexOf("_"));
						 isshowDiv_Fieldid=isshowDiv_Fieldid.replace("field","").replace("$G(\"","");
						 isshowDiv_Fieldid="_"+"\"+i+\""+"_"+isshowDiv_Fieldid;
					 }
					 out.println("if(jQuery(\"div[id^='isshow'][id$='"+isshowDiv_Fieldid+"']\")[0]){");
				     out.println("jQuery(\"div[id^='isshow'][id$='"+isshowDiv_Fieldid+"']\")[0].innerHTML="+targetStr+".innerHTML;");
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
			
            out.println("var transVal;");
			out.println("if("+calExp.substring(0,calExp.indexOf("innerHTML")-9)+").getAttribute('datetype')=='int' && "+calExp.substring(0,calExp.indexOf("innerHTML")-9)+").getAttribute('datavaluetype')!='5'){ ") ;
			out.println("transVal=toPrecision("+calExp.substring(0,calExp.indexOf("innerHTML")-9)+").value,0);");
			out.println(calExp.substring(0,calExp.indexOf("=")).replace("span","_span")+"=transVal;");
			out.println(calExp.substring(0,calExp.indexOf("=")).replace("span","_span_d")+"=transVal;");
			out.println("}else if("+calExp.substring(0,calExp.indexOf("innerHTML")-9)+").getAttribute('datetype')!='int' && "+calExp.substring(0,calExp.indexOf("innerHTML")-9)+").getAttribute('datavaluetype')=='5'){");
			   out.println("transVal=changeToThousandsVal("+calExp.substring(0,calExp.indexOf("innerHTML")-9)+").value)+'';");
               out.println("if("+targetStr+"){");
			     out.println(targetStr+".innerHTML=transVal;");
				  out.println(targetStr.replace("_span","_span_d")+".innerHTML=transVal;");
			   out.println("try{ ");
			   
			   String isshowDiv_Fieldid= "";
		       if(targetStr.indexOf("_")>=0){
		    	  isshowDiv_Fieldid=targetStr.substring(0,targetStr.indexOf("_"));
				  isshowDiv_Fieldid=isshowDiv_Fieldid.replace("field","").replace("$G(\"","");
				  isshowDiv_Fieldid="_"+"\"+i+\""+"_"+isshowDiv_Fieldid;
		       }
		       out.println("if(jQuery(\"div[id^='isshow'][id$='"+isshowDiv_Fieldid+"']\")[0]){");
		       out.println("jQuery(\"div[id^='isshow'][id$='"+isshowDiv_Fieldid+"']\")[0].innerHTML=transVal;");
		       out.println("}");
		       
			   out.println("}catch(ev){} ");
               out.println("}");
                 String targetValue = targetStr.substring(0,targetStr.lastIndexOf("+"))+")";
                 out.println("if("+targetValue+"){");
			     out.println(targetValue+".value=transVal;");
                out.println("}");
			 out.println("}else if("+calExp.substring(0,calExp.indexOf("innerHTML")-9)+").getAttribute('datetype')!='int' && "+calExp.substring(0,calExp.indexOf("innerHTML")-9)+").getAttribute('datavaluetype')=='4'){");
             out.println("try{ ");
					 if(targetStr.indexOf("_")>=0){
						 isshowDiv_Fieldid=targetStr.substring(0,targetStr.indexOf("_"));
						 isshowDiv_Fieldid=isshowDiv_Fieldid.replace("field","").replace("$G(\"","");
						 isshowDiv_Fieldid="_"+"\"+i+\""+"_"+isshowDiv_Fieldid;
					 }
					 
				    out.println("if(jQuery(\"div[id^='isshow'][id$='"+isshowDiv_Fieldid+"']\")[0]){");
					   out.println("if("+targetStr+".innerHTML.indexOf('(')!=-1){");
					   out.println(targetStr+".innerHTML="+targetStr+".innerHTML.substring("+targetStr+".innerHTML.indexOf('(')+1,"+targetStr+".innerHTML.indexOf(')'))");
					   out.println("}");
				        out.println("var moneyFormat ="+targetStr+".innerHTML ");
					   out.println("if(moneyFormat == '' || moneyFormat == 0 || moneyFormat == '0'){");
					    out.println("moneyFormat= '0.00'");
					   out.println("}else{");
					     out.println("moneyFormat= (milfloatFormat(toPrecision("+targetStr+".innerHTML,datalength))); "); 
					   out.println("}");
				       out.println("jQuery(\"div[id^='isshow'][id$='"+isshowDiv_Fieldid+"']\")[0].innerHTML=numberChangeToChinese("+targetStr+".innerHTML)+'('+moneyFormat+')';");
                       out.println(targetStr.replace("_span","_span_d")+".innerHTML=numberChangeToChinese("+targetStr+".innerHTML)+'('+moneyFormat+')';");
					    out.println("if("+targetStr+".getAttribute(\"id\")){");
						 out.println("document.getElementById("+targetStr+".getAttribute(\"id\").replace(\"_span\",\"\")).value="+targetStr+".innerHTML;");
                       out.println("}");
					    out.println(targetStr+".innerHTML=numberChangeToChinese("+targetStr+".innerHTML)+'('+moneyFormat+')';");
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
				  isshowDiv_Fieldid=targetStr.substring(0,targetStr.indexOf("_"));
				  isshowDiv_Fieldid=isshowDiv_Fieldid.replace("field","").replace("$G(\"","");
				  isshowDiv_Fieldid="_"+"\"+i+\""+"_"+isshowDiv_Fieldid;
			  }
			  out.println("if(jQuery(\"div[id^='isshow'][id$='"+isshowDiv_Fieldid+"']\")[0]){");
			  out.println("jQuery(\"div[id^='isshow'][id$='"+isshowDiv_Fieldid+"']\")[0].innerHTML=toPrecision("+calExp.substring(0,calExp.indexOf("innerHTML")-9)+").value,datalength);");
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
				  out.println("if("+targetStr+".value=='Infinity'||"+targetStr+".value=='-Infinity'||"+targetStr+".value=='NaN'){");
				     out.println(""+targetStr+".value=0;");
				  out.println("}");
			     out.println("if("+calExp.substring(0,calExp.indexOf("value")-1)+".datatype=='int'){ "+calExp.substring(0,calExp.indexOf("="))+"=toPrecision("+calExp.substring(0,calExp.indexOf("="))+",0);"
				  +"}else{ "+calExp.substring(0,calExp.indexOf("="))+"=toPrecision("+calExp.substring(0,calExp.indexOf("="))+",datalength);}}");
				 out.println("if(i.indexOf('_d')==-1){");
					 out.println(calExp.substring(0,calExp.indexOf("value")-2)+"+\"_d\").value=toPrecision("+calExp.substring(0,calExp.indexOf("="))+",datalength)");
					 out.println(calExp.substring(0,calExp.indexOf("value")-2)+"+\"_d\").onchange();");
				 out.println("}else{");
				     out.println(calExp.substring(0,calExp.indexOf("value")-2)+"+\"\").value=toPrecision("+calExp.substring(0,calExp.indexOf("="))+",datalength)");
					 out.println(calExp.substring(0,calExp.indexOf("value")-2)+"+\"\").onchange();");
				  out.println("}");
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
    var datalength = 2;
	<%
		for(int m=0;m<mainCalAry.size();m++){
			String str2 =  mainCalAry.get(m).toString();
		    int idx = str2.indexOf("=");
			String str3 = str2.substring(0,idx);
			str3 = str3.substring(str3.indexOf("_")+1);
			String str4 = str2.substring(idx);
			str4 = str4.substring(str4.indexOf("_")+1);
	%>
                var sum=getFieldSumValue("<%=str4 %>");
                if(sum!=null){
				   try{
						if($GetEle("field<%=str3%>")){
							  datalength = $GetEle("field<%=str3%>").getAttribute("datalength");
						  if($GetEle("field<%=str3%>").getAttribute("datatype")=="int")
							  document.getElementById("field<%=str3%>").value=toPrecision(sum,0);
						  else
							  document.getElementById("field<%=str3%>").value=toPrecision(sum,datalength);
						}
			
					if($GetEle("field<%=str3%>")){
						if(document.getElementById("field<%=str3%>")&&document.getElementById("field<%=str3%>").getAttribute("datatype")=="text"){
							document.getElementById("field<%=str3%>_span").innerHTML="";
						}else{
							if(document.getElementById("field<%=str3%>").getAttribute("datatype") == "int"){
							   if(document.getElementById("field<%=str3%>_span")){
									document.getElementById("field<%=str3%>_span").innerHTML=toPrecision(sum,0);
							   }
							   if(document.getElementById("field<%=str3%>")){
									 document.getElementById("field<%=str3%>").value=toPrecision(sum,0);
							   }
							}else if(document.getElementById("field<%=str3%>").getAttribute("datatype")=="float" && document.getElementById("field<%=str3%>").getAttribute("datavaluetype")== "5"){
								if(document.getElementById("field<%=str3%>_span")){
									document.getElementById("field<%=str3%>_span").innerHTML=changeToThousandsVal(toPrecision(sum,datalength)); 
								}
								if(document.getElementById("field<%=str3%>")){
									document.getElementById("field<%=str3%>").value=changeToThousandsVal(toPrecision(sum,datalength)); 
								}
							}else{
								 if(document.getElementById("field<%=str3%>_span")){
									 document.getElementById("field<%=str3%>_span").innerHTML=toPrecision(sum,datalength);
								 }
								
								try{
									 if(document.getElementById("field<%=str3%>").getAttribute("datavaluetype")){
										   var filedtype=document.getElementById("field<%=str3%>").getAttribute("datavaluetype");
											if(filedtype == 4){
												 if(document.getElementById("field_lable<%=str3%>")){
												  document.getElementById("field_lable<%=str3%>").value=toPrecision(sum,datalength);
												   try{
													  numberToFormat(<%=str3%>);
												   }catch(e){
												   }
												}
												if(document.getElementById("field<%=str3%>_span")){
													 document.getElementById("field<%=str3%>_span").innerHTML=numberChangeToChinese(toPrecision(sum,datalength))+'&nbsp;('+toPrecision(sum,datalength)+')';
												}
										   }
									  }
								}catch(e){}
							}
							
						}
						try{
								var changeCount = $("#field<%=str3%>").attr("changeCount");
							   if(changeCount!= $("#field<%=str3%>").val()){
                                  
								   $("#field<%=str3%>").attr("changeCount",$("#field<%=str3%>").val());
                                   $("#field<%=str3%>").change();
							   }
							}catch(e){}

					}
				   }catch(e){}
			   }
	     <%}%>
}
</script>