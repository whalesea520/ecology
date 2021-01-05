<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.workflow.datainput.DynamicDataInput" %>
<%@ page import="java.util.*,weaver.conn.RecordSet" %>
<%@ page import="weaver.general.Util,java.util.Map.Entry,weaver.general.TimeUtil" %>
<%@ page import="java.util.Hashtable" %>
<%@page import="java.net.URLEncoder"%>
<%@ page import="com.alibaba.fastjson.*"%>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs1" class="weaver.conn.RecordSet" scope="page" />
<%
String fformid=Util.null2String(request.getParameter("formid"));
String wflid=request.getParameter("id");
String triggerfieldnameS = Util.null2String(request.getParameter("trg"));
String triggerfieldnameV = Util.null2String(request.getParameter("trgv"))+" ";
String rand = request.getParameter("rand");
String isbill=request.getParameter("bill");
String nodeid=request.getParameter("node");
int tableid=0;
int detailsum=Util.getIntValue(request.getParameter("detailsum"),0);
String inputchecks="";
String refText = Util.null2String(request.getHeader("referer"));
boolean iscreatepage = true ;
if(!refText.equals("")&&refText.indexOf("/workflow/request/ManageRequest")!=-1){
	iscreatepage = false ;
}
//本次触发需要的取值字段的值
String trgInFieldVals = "";
%>
<!-- 
<script type="text/javascript" src="/wui/common/js/ckeditor/ckeditor_wev8.js"></script>
<script type="text/javascript" src="/wui/common/js/ckeditor/ckeditorext_wev8.js"></script>
 -->
 <SCRIPT language="javascript" src="/workflow/request/js/dataInput.js"></script>
 <script type="text/javascript" src="/wui/common/jquery/jquery.min_wev8.js"></script>
<script language="javascript">
window.onload = function (){
<%
// 代码执行的位置
Map<String,String> reqeuestFieldMap=null;
ArrayList triggerfieldnameArr = Util.TokenizerString(triggerfieldnameS,",");
ArrayList triggerfieldnametemparr = new ArrayList();
String[] triggerFieldValueArr = triggerfieldnameV.split(",");
long t = System.currentTimeMillis() ;
for(int temp=0; temp < triggerfieldnameArr.size();temp++){
    String triggerfieldname = Util.null2String((String)triggerfieldnameArr.get(temp));
    if(triggerfieldnametemparr.contains(triggerfieldname)){
    	 continue ;
    }else{
        triggerfieldnametemparr.add(triggerfieldname);
    }
    String triggerfieldV = "";
    try{
        triggerfieldV = Util.null2String(triggerFieldValueArr[temp]);
    }catch(Exception e){
        triggerfieldV = "" ;
    }
    // --- end
    if(triggerfieldname!=null && !triggerfieldname.trim().equals("")){
        DynamicDataInput DDI = new DynamicDataInput(wflid,triggerfieldname,isbill);
        ArrayList clearjs=new ArrayList();
        try{
        clearjs = DDI.ClearMainField(wflid,triggerfieldname,isbill,nodeid);
        for(int i=0;i<clearjs.size();i++){
            String tempjs = (String)clearjs.get(i);
            String lltempjs = tempjs;
            if("".equals(Util.null2String(tempjs))){
                continue;
            }
            lltempjs = lltempjs.substring("window.parent.document.getElementById(\\\"".length(), lltempjs.indexOf("\\\")"));
            tempjs = tempjs.replaceAll("window.parent.document.getElementById\\(", "getElementByDocument\\(window.parent.document, ");
%>
        //页面输出字段值初始化（主字段值清除） 
        try{ // add by liaodong for qc76669 in 20131009 start 对象为空的时候不需要处理
           eval("<%=tempjs%>");
           //字段联动触发完毕后，手动触发触发目标对象的change事件
            var trgelement = getElementByDocument(window.parent.document, "<%=lltempjs %>");           
			window.setTimeout(function(){
			window.parent.jQuery(trgelement).trigger("change");
			},100);
            //window.parent.jQuery(trgelement).focus();
            window.parent.jQuery(trgelement).blur();
            if(!isIE()){
		        window.parent.datainput("<%=lltempjs %>");
		    }
        }catch(e){} //end
<%      }// end for
        }catch(Exception e){
            e.printStackTrace();
        }
        try{
        String sql="select id from Workflow_DataInput_entry where WorkFlowID="+wflid+" and TriggerFieldName='"+triggerfieldname+"'";
        rs.executeSql(sql);
        //System.out.println(sql);
        String entryid="";
        String datainputid="";
        Hashtable outdatahash=new Hashtable();
        while(rs.next()){
            entryid=rs.getString("id");
            String _sql = "select id,IsCycle,WhereClause from Workflow_DataInput_main where entryID="+entryid+" order by orderid" ;
            rs1.executeSql(_sql);
            //System.out.println(_sql);
            String sql1="";
            ArrayList outfieldnamelist=new ArrayList();
            ArrayList outdatasList=new ArrayList();
            ArrayList[] templist=new ArrayList[10];
            ArrayList[] templistdetail=new ArrayList[10];
            String[] isclear=new String[10];
            String[] iscleardetail=new String[10];
            
            ArrayList groupids = null ;
        
            while(rs1.next()){
                isclear[tableid]="1";
                iscleardetail[tableid]="1";
                templist[tableid]=new ArrayList();
                templistdetail[tableid]=new ArrayList();
                datainputid=rs1.getString("id");
                
                groupids = DDI.GetOutFieldIndex(datainputid);//查询出明细个数
                                
                ArrayList infieldnamelist=DDI.GetInFieldName(datainputid);
                for(int i=0;i<infieldnamelist.size();i++){
                    String inFieldName = datainputid+"|"+(String)infieldnamelist.get(i);
                    String inFieldValue = Util.null2String(request.getParameter(inFieldName));
                    DDI.SetInFields((String)infieldnamelist.get(i),inFieldValue);
                    trgInFieldVals += inFieldName + ":" + inFieldValue + ",";
                }
                ArrayList conditionfieldnameList=DDI.GetConditionFieldName(datainputid);
                for(int j=0;j<conditionfieldnameList.size();j++){
                    String inFieldName = datainputid+"|"+(String)conditionfieldnameList.get(j);
                    String inFieldValue = Util.null2String(request.getParameter(inFieldName));
                    DDI.SetConditonFields((String)conditionfieldnameList.get(j),inFieldValue);
                    trgInFieldVals += inFieldName + ":" + inFieldValue + ",";
                }
                //进行加密处理，防止在JS出现错误
                trgInFieldVals = Util.getEncrypt(trgInFieldVals);
                //DDI.GetOutData(datainputid);
                DDI.GetOutDataWithIndex(datainputid,"0");
                outfieldnamelist=DDI.GetOutFieldNameList();
                //outdatasList=DDI.GetOutDataList() ;
                outdatasList=DDI.GetOutDataWithIndex(datainputid,"0") ;
                //System.out.println("DDI.GetIsCycle()="+DDI.GetIsCycle()+"  outfieldnamelist.size = "+outfieldnamelist.size()+"  outdatasList.size = "+outdatasList.size());
                //主表字段更新
                if(DDI.GetIsCycle().equals("1")){
                    for(int i=0;i<outdatasList.size();i++){
                        outdatahash = (Hashtable)outdatasList.get(i);
                        for(int j=0; j<outfieldnamelist.size(); j++){
                            String tempName = Util.null2String((String)outfieldnamelist.get(j));
                            String tempValue = (String)outdatahash.get(outfieldnamelist.get(j));
                            tempValue = Util.toExcelData(tempValue);
                            tempValue = Util.StringReplace(tempValue,";","┌weaver┌");
                            //zzw ChangeMainField.
                            String js=DDI.ChangeMainField(tempName,tempValue,isbill,nodeid,triggerfieldname,false,reqeuestFieldMap);
                            js = Util.StringReplace(js,"&quot；","\\\\\\\"");
                            js = Util.StringReplace(js,"\''", "\'");
							int  strlen;       
							 String  destr   =   "";
							 String  destr1   =   "";
							 strlen   =   js.length();       
							 for(int k=0;k<strlen;k++)       
							 {       
								  char   ch=js.charAt(k);       
								  switch   (ch)       
								  {       
								  case   13:       
								  destr   =   "<br>";       
								  break;   
								  default   :       
								  destr   =   ""   +   ch;       
								  break;       
								  }       
								  destr1   =   destr1   +   destr;       
							 }
							js = destr1;
                            js = js.replaceAll("window.parent.document.getElementById\\(", "getElementByDocument\\(window.parent.document, ");
%>
try{
    var mainjs="<%=js%>";
    var temp=mainjs;
    var spaninx=temp.indexOf(";");                  
    mainjs="";
    var indx=0;
    if(spaninx>0){
        mainjs+=temp.substring(spaninx+1,temp.length);
        temp=temp.substring(0,spaninx);                     
    }
    while(temp.length>0){
        indx=temp.indexOf("<br>");
        if(indx>=0){
            mainjs+=temp.substring(0,indx)+"\\"+"r"+"\\"+"n";
            temp=temp.substring(indx+4,temp.length);
        }else{
            mainjs+=temp;
            temp="";
        }
    }
    mainjs = mainjs.replace(/┌weaver┌/g,";");
    eval(mainjs);
    window.parent.hoverShowNameSpan(".e8_showNameClass");
    //字段联动触发完毕后，手动触发触发目标对象的change事件
    try{
    var trgelement = getElementByDocument(window.parent.document, "<%=tempName %>");
    window.parent.jQuery(trgelement).attr("onafterpaste","");
	window.setTimeout(function(){
			window.parent.jQuery(trgelement).trigger("change");
	},100);
    //window.parent.jQuery(trgelement).focus();
    window.parent.jQuery(trgelement).blur();
    if(!isIE()){
        window.parent.datainput("<%=tempName %>");
    }
    try{
    	window.parent.triggerCallback("<%=tempName %>");
}catch(e){if(window.console)console.log(e)}
	//修改显示属性将原先可编辑的浏览按钮改为只读后，联动出来的内容可删除的问题
	var fieldelement = window.parent.jQuery(trgelement);
	var spanid = fieldelement.attr("id")+"_readonlytext";
	var ddielement = window.parent.jQuery("#"+spanid);
	if(fieldelement.attr('viewtype') == '0'){
		ddielement.find(".e8_delClass").remove();
	}
    }catch(e1){
        if(window.console) console.log("E1 Error : "+e1.message);
    }
}catch(e){
	if(window.console) console.log("E Error : "+e.message);
}
<%
		        		}
	       			}
	       		for (Object outfieldname : outfieldnamelist) {%>
					checkViewType('#<%=(String)outfieldname%>', '#<%=outfieldname%>spanimg'); 	
				<%}
	       		
                %>
                
                var needTriDetail = true;
                var inFieldVals = '<%=trgInFieldVals%>';
                if ("<%=triggerfieldV %>" === "") {
                	window.parent._datainputFrom_<%=datainputid%> = null;
                	needTriDetail = false;
                } else if (window.parent._datainputFrom_<%=datainputid%> && inFieldVals === window.parent._datainputFrom_<%=datainputid%>) {
                    needTriDetail = false;
                }
                if (needTriDetail) {
                	window.parent._datainputFrom_<%=datainputid%> = inFieldVals;
                <%
                
				//主表触发明细表开始
	      		for(int dtidx = 0 ; dtidx < groupids.size() ; dtidx++){
	      			int tmpgroupid = Util.getIntValue(groupids.get(dtidx).toString(),1) ;
	      			int groupid = getNewGroupid(Util.getIntValue(fformid,0),tmpgroupid);
	      			int jsgroupid = groupid -1 ;

	      			outfieldnamelist = DDI.GetOutFieldNameListWithIndex(datainputid,tmpgroupid+"") ;
	      			outdatasList = DDI.GetOutDataWithIndex(datainputid,tmpgroupid+"");//DDI.GetOutDataList();
	      			for(int i=0;i<outdatasList.size();i++){
			 		outdatahash = (Hashtable)outdatasList.get(i);
	      			
			 		StringBuffer javaScript_dtidx = new StringBuffer();
			 		javaScript_dtidx.append("function _flag_DataInputFromAjax_done_dtidx_"+dtidx+"_i_"+i+"(______index){");
			 		javaScript_dtidx.append("	try{");
			 		javaScript_dtidx.append("		if(true ");
			 		%>
			 		try{
						try{
							window.parent.addRow<%=jsgroupid %>(<%=jsgroupid %>,<%=jsgroupid %>);
						}catch(e){}
		 		    var dtidx = getElementByDocument(window.parent.document,"indexnum<%=jsgroupid %>").value ;
		 		    <%
			 		for(int j=0; j<outfieldnamelist.size(); j++){
			 			String tempfieldname = outfieldnamelist.get(j).toString() ;
			 		    String tempValue = (String)outdatahash.get(tempfieldname);
			 		    tempValue = Util.StringReplace(tempValue,"\n","");
			 		    tempValue = Util.StringReplace(tempValue,"\r","");
			 		    tempValue = Util.StringReplace(tempValue,"\t","");
			 		    tempValue = Util.StringReplace(tempValue,"<","&lt;");
			 		    tempValue = Util.StringReplace(tempValue,">","&gt;");
			 		    //tempValue = Util.toExcelData(tempValue);
			 		    tempValue = Util.StringReplace(tempValue,";","┌weaver┌");
			 		    %>
			 		    var _flag_DataInputFromAjax_done_dtidx_<%=dtidx%>_i_<%=i%>_j_<%=j%> = false;
			 		    <%
			 		    javaScript_dtidx.append("\r\n && _flag_DataInputFromAjax_done_dtidx_"+dtidx+"_i_"+i+"_j_"+j+"");
			 		    %>
			 		    jQuery.ajax({
			 		    	url:"/workflow/request/DataInputFromAjax.jsp",
			 		    	data:{dtidx:dtidx,isbill:'<%=isbill%>',formid:'<%=fformid%>',nodeid:"<%=nodeid%>",id:"<%=wflid%>",fieldname:"<%=tempfieldname%>",fieldvalue: "<%=tempValue%>",groupid:"<%=groupid%>",triggerfieldname:"<%=triggerfieldname %>",tempflag:Math.random()},
			 		    	dataType:'text',
			 		    	success:function(resultdata){
								var index = resultdata.substring(0,resultdata.indexOf(";",1));
								var data = resultdata.substring(resultdata.indexOf(";",1))
			 		    		ajaxcallback(data) ;
								try{
									if(getElementByDocument(window.parent.document,"<%=tempfieldname %>_"+index).fireEvent){
										getElementByDocument(window.parent.document,"<%=tempfieldname %>_"+index).fireEvent('onchange');
									}else{
										getElementByDocument(window.parent.document,"<%=tempfieldname %>_"+index).onchange();
									}
								}catch(e){
								}
								
								window.parent.datainputd("<%=tempfieldname %>_"+index);
								try{
									window.parent.calSum(<%=groupid-1%>,true,index);
								}catch(ec){
								}
								
								_flag_DataInputFromAjax_done_dtidx_<%=dtidx%>_i_<%=i%>_j_<%=j%> = true;
								try{_flag_DataInputFromAjax_done_dtidx_<%=dtidx%>_i_<%=i%>(index);}catch(ec001){}
			 		    	},
							error:function(error){ 
								if(window.console){ console.log("error"+error);}
							}
							});
			 		    <%
			 		}//end outfieldnamelist
			 		%>
			 		<%
			 		javaScript_dtidx.append("){ ");
			 		javaScript_dtidx.append("			window.parent.getOrgSpanAndInitOrgIdBtn_defalutFieldValue(______index); ");
			 		javaScript_dtidx.append("		} ");
			 		javaScript_dtidx.append("	}catch(exc001){}");
			 		javaScript_dtidx.append("}");
			 		%>
			 		<%=javaScript_dtidx.toString() %>
			 		}catch(e){
			 			if(window.console){ console.log(e.message);}
			 		}
		 			<%
	      			}//end outdataslit
	      		}
	     		//主表触发明细字段结束
	     		%>
	     		}
	     		<%
	       		//明细表字段更新
		       	} else {
		       		ArrayList viewfields=new ArrayList();
		       		if(outdatasList.size()>0){
		       			viewfields=DDI.ViewDetailFieldList(fformid,nodeid,tableid);
		       		}
		       		
			       	for(int i=0;i<outdatasList.size();i++){
			       		outdatahash=(Hashtable)outdatasList.get(i);
			       		String html="";
			       		if(outdatahash.size()>0 && outfieldnamelist.size()>0){
%>

try{
	var oTable=window.parent.document.getElementById('oTable<%=tableid%>');
	curindex=parseInt(window.parent.document.getElementById('nodesnum<%=tableid%>').value);
	rowindex=parseInt(window.parent.document.getElementById('indexnum<%=tableid%>').value);
	oRow = oTable.insertRow(curindex+1);
	oCell = oRow.insertCell(-1); 
	oCell.style.height=24;
	oCell.style.background= "#E7E7E7";
	var oDiv = window.parent.document.createElement("div");
	var sHtml = "<input type='checkbox' name='check_node<%=tableid%>' value='"+rowindex+"'>";
	oDiv.innerHTML = sHtml;
	oCell.appendChild(oDiv);
}catch(e){}
		        
<%
						}
					
			        	for(int j=0;j<viewfields.size();j++){
			        		int outindx=outfieldnamelist.indexOf(viewfields.get(j));
			        		if(outindx>-1){
			        			html=DDI.addcol((String)outfieldnamelist.get(outindx),(String)outdatahash.get(outfieldnamelist.get(outindx)),isbill,nodeid,triggerfieldname,i,tableid);
			        		} else {
			        			html=DDI.addcol((String)viewfields.get(j),"",isbill,nodeid,triggerfieldname,i,tableid);
			        		}
			        		
			        		if(!html.trim().equals("")){
%>

try{
	oCell = oRow.insertCell(-1); 
	oCell.style.height=24;
	oCell.style.background= "#E7E7E7";
	var oDiv = window.parent.document.createElement("div");
	var mainjs="<%=html%>";
	var temp=mainjs;
	var spaninx=temp.indexOf("<span notview");
	mainjs="";
	var indx=0;
	if(spaninx>0){
		mainjs+=temp.substring(spaninx,temp.length);
		temp=temp.substring(0,spaninx);				
	}
	while(temp.length>0){					
		indx=temp.indexOf("<br>");
		if(indx>=0){
			mainjs+=temp.substring(0,indx)+"\r\n";
			temp=temp.substring(indx+4,temp.length);							
		}else{
			mainjs+=temp;
			temp="";
		}
	}
	oDiv.innerHTML = mainjs;
	oCell.appendChild(oDiv);
}catch(e){}

<%
		        			}
		        		}
%>

try{
	rowindex = rowindex*1 +1;
	curindex = curindex*1 +1;
	window.parent.document.getElementById("nodesnum<%=tableid%>").value=curindex;
	window.parent.document.getElementById("indexnum<%=tableid%>").value=rowindex;
	window.parent.calSum(<%=tableid%>);
}catch(e){}

<%
		        	}
			       	if(outdatasList.size()>0){
			       		tableid++;
			       	}
	        	}
			}
		}// end rs while
		}catch(Exception e){
			//System.out.println("查询数据出现异常：："+e.getMessage());
			e.printStackTrace();
		}
		inputchecks=DDI.GetNeedCheckStr();
	}
}
%>

try{
	window.parent.document.getElementById("inputcheck").value=window.parent.document.getElementById("inputcheck").value+"<%=inputchecks%>";
}catch(e){}
}

function delall(){
	try{
<%  for(int j=0;j<detailsum;j++){  %>
  	var oTable=window.parent.document.getElementById('oTable<%=j%>');
    len = window.parent.document.forms[0].elements.length;
    var i=0;
    var rowsum1 = 0;
    for(i=len-1; i >= 0;i--) {
        if (window.parent.document.forms[0].elements[i].name=='check_node<%=j%>')
            rowsum1 += 1;
    }
    for(i=len-1; i >= 0;i--) {
        if (window.parent.document.forms[0].elements[i].name=='check_node<%=j%>'){
            oTable.deleteRow(rowsum1);
            rowsum1 -=1;
        }
    }
    window.parent.calSum(<%=j%>);
    window.parent.document.getElementById("nodesnum<%=j%>").value="0";
	window.parent.document.getElementById("indexnum<%=j%>").value="0";
<%  }  %>
  }catch(e){}
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

function getElementByDocument(_document, identity) {
	return $GetEle(identity, _document);
}

function checkViewType(ele, elespan) {
	var _jQuery = window.parent.jQuery;
	if (!!_jQuery) {
		if (1 == _jQuery(ele).attr('viewtype')) {
			if (!!_jQuery(ele).val()) {
				_jQuery(elespan).html('');
			} else {
				_jQuery(elespan).html('<img src="/images/BacoError_wev8.gif" align=absmiddle>');
			}
		} else {
			_jQuery(elespan).html('');
		}
	}
}

//属性联动为只读，然后字段联动后只读不显示
function setEditTextareaValue(fieldid,fieldval) {

	var _zjQuery = window.parent.jQuery;
    //在这里把值赋给只读的多行文本框的span
    if (!!_zjQuery) {
	
    	if (0 == _zjQuery(fieldid).attr('viewtype')) {

    		var _zfield = _zjQuery(fieldid).attr('id');
			
			var _zfieldspan =_zfield+'_readonlytext';

			_zjQuery("#"+_zfieldspan).html(fieldval);
    	}
    }
	
}

function ajaxcallback(data){
	try{
			var maindtjs= data ;
			var tempdtjs = maindtjs;
			var spaninxdt = tempdtjs.indexOf(";");					
			maindtjs = "";
			var indxdt=0;
			if(spaninxdt>0){
				maindtjs += tempdtjs.substring(spaninxdt+1,tempdtjs.length);
				tempdtjs = tempdtjs.substring(0,spaninxdt);						
			}
			while(tempdtjs.length>0){
				indxdt = tempdtjs.indexOf("<br>");
				if(indxdt >= 0){
					maindtjs+=tempdtjs.substring(0,indxdt)+"\\"+"r"+"\\"+"n";
					tempdtjs=tempdtjs.substring(indxdt+4,tempdtjs.length);
				}else{
					maindtjs+=tempdtjs;
					tempdtjs ="";
				}
			}
			maindtjs = maindtjs.replace(/┌weaver┌/g,";");
			eval(maindtjs);
		}catch(e){
			//if(window.console){ console.log(e.message);}
		}
}
function isIE(){
      return (document.all && window.ActiveXObject && !window.opera) ? true : false;
} 
</script>
<%!
public ArrayList<String> requestvalue(String fieldname,HttpServletRequest request){
	ArrayList<String> fieldvalue = new ArrayList<String>();
	try{
	Iterator iterator = request.getParameterMap().entrySet().iterator(); 
	   int i = 0;
	   while (iterator.hasNext()) {  
	       i++;
	       Entry entry = (Entry) iterator.next();
	       String tempfieldvalue = "";
	       if(entry.getKey().toString().indexOf("|field")!=-1){
	    	   if (entry.getValue() instanceof String[]) {  
	    		   String[]  env = (String[])entry.getValue() ;
	    		   for(String e : env){
		    		   tempfieldvalue = e ;
		    		   if(tempfieldvalue.equals("")) tempfieldvalue = "null" ;
			    	   fieldvalue.add(entry.getKey()+"_"+tempfieldvalue) ;
	    		   }
	           } else {  
	        	   tempfieldvalue = entry.getValue().toString() ;
	        	   if(tempfieldvalue.equals("")) tempfieldvalue = "null" ;
		    	   fieldvalue.add(entry.getKey()+"_"+tempfieldvalue) ;
	           }
	       }
	   }
	}catch(Exception e){
		//System.out.println(e.getMessage());
	} 
	return fieldvalue ;
}

public int getNewGroupid(int billid,int groupid){
	RecordSet rs = new RecordSet();
	int newgroupid = 0 ;
	String sql = "";
	if(rs.getDBType().equals("oracle")){
		sql = " SELECT t.rid FROM (select rownum as rid,orderid from (SELECT tablename, orderid FROM Workflow_billdetailtable  WHERE billid = "+billid+" order by id) t1) t WHERE t.orderid="+groupid ;
	}else{
		sql = "SELECT t.rowid FROM (SELECT ROW_NUMBER() OVER (ORDER BY ORDERid) AS rowid ,tablename,orderid FROM Workflow_billdetailtable WHERE billid="+billid+" ) t WHERE t.orderid="+groupid ;
	}
	rs.executeSql(sql);
	if(rs.next()){
		newgroupid = rs.getInt(1);
	}else{
		newgroupid = groupid ;
	}

	return newgroupid ;
}
%>