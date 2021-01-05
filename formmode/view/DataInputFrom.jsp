<%@page import="com.weaver.formmodel.util.StringHelper"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="java.util.*" %>
<%@ page import="weaver.general.Util,java.util.Map.Entry,weaver.general.TimeUtil" %>
<%@ page import="java.util.Hashtable" %>
<%@ page import="java.net.URLEncoder"%>
<%@ page import="weaver.formmode.datainput.DynamicDataInput"%>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs1" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs2" class="weaver.conn.RecordSet" scope="page" />
<%
String fformid=Util.null2String(request.getParameter("formid"));
String modeid=Util.null2String(request.getParameter("modeId"));
String triggerfieldnameS = Util.null2String(request.getParameter("trg"));
String triggerfieldnameV = Util.null2String(request.getParameter("trgv"))+" ";
String rand = request.getParameter("rand");
int detailsum=Util.getIntValue(request.getParameter("detailsum"),0);
int layoutid = Util.getIntValue(request.getParameter("layoutid"), 0);
int type = Util.getIntValue(request.getParameter("type"),0);
int tableid=0;
String inputchecks="";
boolean iscreatepage = true ;
if(type!=1){
	iscreatepage = false ;
}
%>
<script type="text/javascript" src="/wui/common/jquery/jquery.min_wev8.js"></script>
<script language="javascript" src="/formmode/js/dataInput.js"></script>
<script language="javascript">
window.onload = function (){
<%
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
    boolean istriggerdetail = true ;
    try{
        String triggerfieldV = "" ;
        try{
            triggerfieldV = Util.null2String(triggerFieldValueArr[temp]);
        }catch(Exception e){
            // to null ;
            triggerfieldV = "" ;
        }
        String trgv_s = Util.null2String(session.getAttribute(modeid+"_"+triggerfieldname+"_"+rand));
        boolean trgf_s = Util.null2String(session.getAttribute(modeid+"_"+triggerfieldname+"_"+rand+"_flag")).equals("true")?true:false;
        long trgt_s = Long.parseLong(Util.null2String((String)session.getAttribute(modeid+"_"+triggerfieldname+"_"+rand+"_time"),"0"),10);
        if(t-trgt_s < 1000){
            if(trgf_s){
                istriggerdetail = trgf_s ;
                trgv_s = "";
            }
        }   
        if(iscreatepage){
            if(triggerfieldV.equals("")||(!trgv_s.equals("")&&trgv_s.equalsIgnoreCase(triggerfieldV))){
                istriggerdetail = false ;
            }
        }else{
            if(istriggerdetail&&triggerfieldV.equals("")){
                istriggerdetail = false ;
            }
            if(istriggerdetail&&(trgv_s.equalsIgnoreCase(triggerfieldV))){
                istriggerdetail = false ;
            }
        }
        
        session.setAttribute(modeid+"_"+triggerfieldname+"_"+rand,triggerfieldV);
        session.setAttribute(modeid+"_"+triggerfieldname+"_"+rand+"_flag",String.valueOf(istriggerdetail));
        session.setAttribute(modeid+"_"+triggerfieldname+"_"+rand+"_time",t+"");
    }catch(Exception e){
        e.printStackTrace();
    }
    // --- end
    if(triggerfieldname!=null && !triggerfieldname.trim().equals("")){
        DynamicDataInput DDI = new DynamicDataInput(modeid,type,layoutid);
        ArrayList clearjs=new ArrayList();
        try{
        clearjs = DDI.ClearMainField(triggerfieldname);
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
            window.parent.jQuery(trgelement).trigger("change");
            window.parent.jQuery(trgelement).focus();
            window.parent.jQuery(trgelement).blur();
        }catch(e){} //end
<%      }// end for
        }catch(Exception e){
        }
        try{
        String sql="select id from modedatainputentry where modeid="+modeid+" and TriggerFieldName='"+triggerfieldname+"'";
        rs.executeSql(sql);
        String entryid="";
        String datainputid="";
        Hashtable outdatahash=new Hashtable();
        while(rs.next()){
            entryid=rs.getString("id");
            String _sql = "select id,IsCycle,WhereClause from modedatainputmain where entryID="+entryid+" order by orderid" ;
            rs1.executeSql(_sql);
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
                Map treenodeids = DDI.getTreeNodeIds();
                ArrayList<String> infieldvalues = new ArrayList<String>();
                for(int i=0;i<infieldnamelist.size();i++){
                	String value = Util.null2String(request.getParameter(datainputid+"|"+(String)infieldnamelist.get(i)));
                	String treenodeid = Util.null2String(treenodeids.get(datainputid+"|"+(String)infieldnamelist.get(i)));
                	if(!StringHelper.isEmpty(treenodeid)) {	
                		String [] values = value.split("_");
                		if(values.length > 1) {
                			if(!values[0].equals(treenodeid)){
                				value = "";
                			}
                		}
                	}
                	infieldvalues.add(value);
                    DDI.SetInFields((String)infieldnamelist.get(i),value);
                }
                int emptycount=0;
				for(int i=0;i<infieldvalues.size();i++){
					if(infieldvalues.get(i).length()==0){
						emptycount++;
					}
				}
				if(emptycount==infieldvalues.size()){
					continue;
				}
                //DDI.GetOutData(datainputid);
                DDI.GetOutDataWithIndex(datainputid,"0");
                outfieldnamelist=DDI.GetOutFieldNameList();
                //outdatasList=DDI.GetOutDataList() ;
                outdatasList=DDI.GetOutDataWithIndex(datainputid,"0") ;
                //主表字段更新
                if(DDI.GetIsCycle().equals("1")){
                    for(int i=0;i<outdatasList.size();i++){
                        outdatahash = (Hashtable)outdatasList.get(i);
                        for(int j=0; j<outfieldnamelist.size(); j++){
                            String tempName = Util.null2String((String)outfieldnamelist.get(j));
                            String tempValue = (String)outdatahash.get(outfieldnamelist.get(j));
                            tempValue = Util.toExcelData(tempValue);
                            tempValue = Util.StringReplace(tempValue,";","┌weaver┌");
                            String js=DDI.ChangeMainField(tempName,tempValue,triggerfieldname);
                            js = Util.StringReplace(js,"&quot；","\\\\\\\"");
                            js = Util.StringReplace(js,"\''", "\'");
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
    window.parent.jQuery(trgelement).trigger("change");
    window.parent.jQuery(trgelement).focus();
    window.parent.jQuery(trgelement).blur();
    if(!isIE()){
        window.parent.datainput("<%=tempName %>");
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
                //主表触发明细表开始
                if(istriggerdetail){
                for(int dtidx = 0 ; dtidx < groupids.size() ; dtidx++){
                    int groupid = Util.getIntValue(groupids.get(dtidx).toString(),1) ;
                    outfieldnamelist = DDI.GetOutFieldNameListWithIndex(datainputid,groupid+"") ;
                    outdatasList = DDI.GetOutDataWithIndex(datainputid,groupid+"");//DDI.GetOutDataList();
                    for(int i=0;i<outdatasList.size();i++){
                    outdatahash = (Hashtable)outdatasList.get(i);
                    %>
                    try{
                    window.parent.addRow<%=groupid-1%>(<%=groupid-1%>,<%=groupid-1%>);
                    var dtidx = getElementByDocument(window.parent.document,"indexnum<%=groupid-1%>").value ;
                    if(window.console) console.log("dtidx  ====   "+dtidx);
                    <%
                    for(int j=0; j<outfieldnamelist.size(); j++){
                        String tempfieldname = outfieldnamelist.get(j).toString();
                        String tempValue = (String)outdatahash.get(tempfieldname);
                        tempValue = Util.StringReplace(tempValue,"\n","");
                        tempValue = Util.StringReplace(tempValue,"\r","");
                        tempValue = Util.StringReplace(tempValue,"\t","");
                        tempValue = Util.StringReplace(tempValue,"<","&lt;");
                        tempValue = Util.StringReplace(tempValue,">","&gt;");
						tempValue = Util.StringReplace(tempValue,"\"","&quot;");
                        //tempValue = Util.toExcelData(tempValue);
                        tempValue = Util.StringReplace(tempValue,";","┌weaver┌");
                        boolean hasChildField = false;
                        if(tempfieldname.length()>5){
                        	String fieldid = tempfieldname.substring(5);
                        	String tmpsql = "select fieldhtmltype,childfieldid from workflow_billfield where id ="+fieldid;
                        	rs2.executeSql(tmpsql);
                        	if(rs2.next()){
                        		String fieldhtmltype = Util.null2String(rs2.getString("fieldhtmltype"));
                        		String childfieldid = Util.null2String(rs2.getString("childfieldid"));
                        		if("5".equals(fieldhtmltype)&&!"".equals(childfieldid)&&!"0".equals(childfieldid)){
                        			hasChildField = true;
                        		}
                        	}
                        }
                        %>
                        
                        jQuery.ajax({
                            url:"/formmode/view/DataInputFromAjax.jsp",
                            data:{dtidx:dtidx,formid:'<%=fformid%>',id:"<%=modeid%>",fieldname:"<%=tempfieldname%>",fieldvalue: "<%=tempValue%>",groupid:"<%=groupid%>",triggerfieldname:"<%=triggerfieldname %>",type:"<%=type%>",layoutid:"<%=layoutid%>",tempflag:Math.random()},
                            dataType:'text',
                            <%
                           	if(hasChildField){//如果有关联子字段，则必须先加载父字段才能加载子字段，此时需要改为同步操作
                           	%>
                           	async:false,
                           	<%
                           	}
                            %>
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
                                window.parent.calSum(<%=groupid-1%>,true,index);
                            },
                            error:function(error){ 
                                if(window.console){ console.log("error"+error);}
                            }
                            });
                        <%
                    }//end outfieldnamelist
                    %>
                    }catch(e){
                        if(window.console){ console.log(e.message);}
                    }
                    <%
                    }//end outdataslit
                }
                }
                //主表触发明细字段结束
                //明细表字段更新
                } else {
                    ArrayList viewfields=new ArrayList();
                    if(outdatasList.size()>0){
                        viewfields=DDI.ViewDetailFieldList(Util.getIntValue(fformid),tableid);
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
                                html=DDI.addcol((String)outfieldnamelist.get(outindx),(String)outdatahash.get(outfieldnamelist.get(outindx)),triggerfieldname,i,tableid);
                            } else {
                                html=DDI.addcol((String)viewfields.get(j),"",triggerfieldname,i,tableid);
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
    } 
    return fieldvalue ;
}
%>