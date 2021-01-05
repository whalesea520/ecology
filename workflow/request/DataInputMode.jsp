<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.workflow.datainput.DynamicDataInput" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.Hashtable,java.util.*,java.util.Map.Entry,weaver.conn.RecordSet" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs1" class="weaver.conn.RecordSet" scope="page" />
<script type="text/javascript" src="/wui/common/jquery/jquery.min_wev8.js"></script>
<%
String fformid=Util.null2String(request.getParameter("formid"));
String wflid=request.getParameter("id");
String triggerfieldnameS=request.getParameter("trg");
String triggerfieldnameV = Util.null2String(request.getParameter("trgv"));
String rand = Util.null2String(request.getParameter("rand"));
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
%>

<script language="javascript">
window.onload=function(){
<%
ArrayList triggerfieldnameArr = Util.TokenizerString(triggerfieldnameS,",");
ArrayList triggerfieldnametemparr = new ArrayList();
String[] triggerFieldValueArr = triggerfieldnameV.split(",");
for(int temp=0;temp<triggerfieldnameArr.size();temp++){
String triggerfieldname = Util.null2String((String)triggerfieldnameArr.get(temp));
if(triggerfieldnametemparr.contains(triggerfieldname)){
     continue ;
}else{
    triggerfieldnametemparr.add(triggerfieldname);
}
boolean istriggerdetail = true ;
boolean isft = false ;
long t = System.currentTimeMillis() ;
try{
	String triggerfieldV = "" ;
	try{
		triggerfieldV = Util.null2String(triggerFieldValueArr[temp]);
	}catch(Exception e){
		// to null ;
		triggerfieldV = "" ;
	}
	String trgv_s = Util.null2String(session.getAttribute(wflid+"_"+triggerfieldname+"_"+rand));
	boolean trgf_s = Util.null2String(session.getAttribute(wflid+"_"+triggerfieldname+"_"+rand+"_flag")).equals("true")?true:false;
	long trgt_s = Long.parseLong(Util.null2String((String)session.getAttribute(wflid+"_"+triggerfieldname+"_"+rand+"_time"),"0"),10);
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
		if(isft||triggerfieldV.equals("")||(!trgv_s.equals("")&&trgv_s.equalsIgnoreCase(triggerfieldV))){
			istriggerdetail = false ;
		}
	}
	session.setAttribute(wflid+"_"+triggerfieldname+"_"+rand,triggerfieldV);
	session.setAttribute(wflid+"_"+triggerfieldname+"_"+rand+"_flag",String.valueOf(istriggerdetail));
	session.setAttribute(wflid+"_"+triggerfieldname+"_"+rand+"_time",t+"");
	
}catch(Exception e){

}


if(triggerfieldname!=null && !triggerfieldname.trim().equals("")){
DynamicDataInput DDI=new DynamicDataInput(wflid,triggerfieldname,isbill);
ArrayList clearjs=new ArrayList();
clearjs=DDI.ClearMainField(wflid,triggerfieldname,isbill,nodeid,true);
//System.out.println(clearjs);
for(int i=0;i<clearjs.size();i++){
	String tempjs=(String)clearjs.get(i);
	tempjs = tempjs.replaceAll("window.parent.document.getElementById\\(", "getElementByDocument\\(window.parent.document, ");
%>
//页面输出字段值初始化（主字段值清除）
eval("<%=tempjs %>");
<%
}
String sql="select id from Workflow_DataInput_entry where WorkFlowID="+wflid+" and TriggerFieldName='"+triggerfieldname+"'";
//System.out.println(sql);
rs.executeSql(sql);
String entryid="";
String datainputid="";
Hashtable outdatahash=new Hashtable();
while(rs.next()){
	entryid=rs.getString("id");
	rs1.executeSql("select id,IsCycle,WhereClause from Workflow_DataInput_main where entryID="+entryid+" order by orderid");
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
        //System.out.println("datainputid:"+datainputid);
		ArrayList infieldnamelist=DDI.GetInFieldName(datainputid);
		for(int i=0;i<infieldnamelist.size();i++){
            //System.out.println((String)infieldnamelist.get(i)+"|"+Util.null2String(request.getParameter(datainputid+"|"+(String)infieldnamelist.get(i))));
			DDI.SetInFields((String)infieldnamelist.get(i),Util.null2String(request.getParameter(datainputid+"|"+(String)infieldnamelist.get(i))));
		}
		ArrayList conditionfieldnameList=DDI.GetConditionFieldName(datainputid);
		for(int j=0;j<conditionfieldnameList.size();j++){
			DDI.SetConditonFields((String)conditionfieldnameList.get(j),Util.null2String(request.getParameter(datainputid+"|"+(String)conditionfieldnameList.get(j))));
		}
        //DDI.GetOutData(datainputid);
        DDI.GetOutDataWithIndex(datainputid,"0");
        outfieldnamelist=DDI.GetOutFieldNameList();
        //outdatasList=DDI.GetOutDataList();
		outdatasList = DDI.GetOutDataWithIndex(datainputid,"0");

       if(DDI.GetIsCycle().equals("1")){   //主表字段更新
       	for(int i=0;i<outdatasList.size();i++){
       		outdatahash=(Hashtable)outdatasList.get(i);
       		for(int j=0;j<outfieldnamelist.size();j++){
				String tempfield = (String)outfieldnamelist.get(j) ;
       		    String tempValue = (String)outdatahash.get(outfieldnamelist.get(j));
       		 	tempValue = Util.toExcelData(tempValue);
       		    tempValue = Util.StringReplace(tempValue,";","┌weaver┌");
       		    //tempValue = Util.StringReplace(tempValue,"\"","\\\\\\\"");
       				String js=DDI.ChangeMainField(tempfield,tempValue,isbill,nodeid,triggerfieldname,true);
       				js = Util.StringReplace(js,"&quot；","\\\\\\\"");
       				js = Util.StringReplace(js,"\''", "\'");
       				js = js.replaceAll("window.parent.document.getElementById\\(", "getElementByDocument\\(window.parent.document, ");
       				//js = Util.toHtmlMode(js);
%>
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
					//多级联动
					window.parent.DataInputByBrowser("<%=outfieldnamelist.get(j)%>");
<%

	        	}
       		}
	        //主表触发明细表
	        if(istriggerdetail){
		   		for(int dtidx = 0 ; dtidx < groupids.size() ; dtidx++){
		   			int groupid = Util.getIntValue(groupids.get(dtidx).toString(),1) ;
		   			int jsgroupid = getNewGroupid(Util.getIntValue(fformid,0),groupid);
		   			session.removeAttribute("outfieldnamelist_"+groupid+"_"+datainputid);
	   				session.removeAttribute("outdatasList_"+groupid+"_"+datainputid);
	   				
		   			outfieldnamelist = DDI.GetOutFieldNameListWithIndex(datainputid,groupid+"") ;
		   			outdatasList = DDI.GetOutDataWithIndex(datainputid,groupid+"");
		   			//System.out.println(groupid+" 联动数据"+outdatasList.size()+" 输出字段数"+outfieldnamelist.size());
		   			for(int idx = 0 ; idx < outdatasList.size() ; idx++ ){
						outdatahash = (Hashtable)outdatasList.get(idx);
		   				session.setAttribute("outfieldnamelist_"+groupid+"_"+datainputid+"_"+idx, outfieldnamelist);
		   				session.setAttribute("outdatasList_"+groupid+"_"+datainputid+"_"+idx, outdatahash );
						%>
				 		try{
				 		 //插入明细行
				 		 window.parent.rowIns("<%=jsgroupid-1%>",1,1);
				 		 var dtidx = 0 ;
				 		 dtidx = getElementByDocument(window.parent.document,"indexnum<%=jsgroupid-1%>").value ;
						 jQuery.ajax({
								url:"/workflow/request/DataInputFromAjaxMode.jsp",
								async:false ,
								data:{dtidx:dtidx,index:"<%=idx%>",isbill:'<%=isbill%>',formid:'<%=fformid%>',nodeid:"<%=nodeid%>",id:"<%=wflid%>",datainputid:"<%=datainputid%>",triggerfieldname:"<%=triggerfieldname %>",groupid:"<%=groupid%>",ismode:"1",rand:"<%=rand %>",tempflag:Math.random()},
								dataType:'text',
								success:function(data){
									ajaxcallback(data) ;
								}
						 });
				 
				 		}catch(e){ 
				 			//if(window.console){ console.log(e.message);} 
				 		}
				 <%
		   			}//end if 
		   		}//end groupid
	        }
       	}else{      //明细表字段更新
        }
	}
}
inputchecks=DDI.GetNeedCheckStr();
}
}
%>
//alert("<%=inputchecks%>");
window.parent.document.getElementsByName("inputcheck")[0].value=window.parent.document.getElementsByName("inputcheck")[0].value+"<%=inputchecks%>";
//$G("inputcheck", window.parent.document).value=$G("inputcheck", window.parent.document).value+"<%=inputchecks%>";
//jQuery("#inputcheck", window.parent.document).val(jQuery("#inputcheck", window.parent.document).val()+"<%=inputchecks%>");
window.parent.frmmain.ChinaExcel.RefreshViewSize();
try{window.parent.frmmain.ChinaExcel.ReCalculate();}catch(e1){}
try{window.parent.frmmain.ChinaExcel.RefreshViewSize();}catch(e2){}
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

function ajaxcallback(data){
	try{
			var maindtjs= data ;
			var tempdtjs = maindtjs;
			var spaninxdt = tempdtjs.indexOf(";");					
			//maindtjs = "";
			/*
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
			*/
			maindtjs = maindtjs.replace(/┌weaver┌/g,";");
			eval(maindtjs);
		}catch(e){
			if(window.console){ console.log("datainput ajax callback:::"+e.message);}
		}
}
</script>
<%!
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