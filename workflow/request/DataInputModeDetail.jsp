
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.workflow.datainput.DynamicDataInput" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.Hashtable" %>

<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs1" class="weaver.conn.RecordSet" scope="page" />
<%
String fformid=Util.null2String(request.getParameter("formid"));
String wflid=request.getParameter("id");
//String triggerfieldname=request.getParameter("trg");
//int indexid=Util.getIntValue(triggerfieldname.substring(triggerfieldname.indexOf("_")+1,triggerfieldname.length()));
//triggerfieldname=triggerfieldname.substring(0,triggerfieldname.indexOf("_"));

String isbill=request.getParameter("bill");
String nodeid=request.getParameter("node");
int tableid=0;
int detailsum=Util.getIntValue(request.getParameter("detailsum"),0);
String inputchecks="";
/*
rs.executeSql("select count(*) from Workflow_billdetailtable where billid="+fformid);
if(rs.next()){
    detailsum=rs.getInt(1);
}
*/
//System.out.println("detailsum:"+detailsum);
%>
<script language="javascript">
window.onload = function (){
<%
String triggerfieldnameS=request.getParameter("trg");
ArrayList triggerfieldnameArr = Util.TokenizerString(triggerfieldnameS,",");
for(int temp=0;temp<triggerfieldnameArr.size();temp++){
String triggerfieldname = Util.null2String((String)triggerfieldnameArr.get(temp));
if(triggerfieldname.equals("")) continue;
int indexid=Util.getIntValue(triggerfieldname.substring(triggerfieldname.indexOf("_")+1,triggerfieldname.length()));
triggerfieldname=triggerfieldname.substring(0,triggerfieldname.indexOf("_"));
//System.out.println("triggerfieldname:"+request.getParameter("triggerfieldname"));
if(triggerfieldname!=null && !triggerfieldname.trim().equals("")){
DynamicDataInput DDI=new DynamicDataInput(wflid,triggerfieldname,isbill,"1");
ArrayList clearjs=new ArrayList();
clearjs=DDI.ClearDetailField(wflid,triggerfieldname,isbill,nodeid,indexid,true);
//System.out.println(clearjs);
for(int i=0;i<clearjs.size();i++){
%>
//页面输出字段值初始化（明细字段值清除）
//alert("<%=clearjs.get(i)%>");
eval("<%=clearjs.get(i)%>");
<%
}
String sql="select id from Workflow_DataInput_entry where WorkFlowID="+wflid+" and type='1' and  TriggerFieldName='"+triggerfieldname+"'";
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

	while(rs1.next()){
		isclear[tableid]="1";
		iscleardetail[tableid]="1";
		templist[tableid]=new ArrayList();
		templistdetail[tableid]=new ArrayList();
		datainputid=rs1.getString("id");
        //System.out.println("datainputid:"+datainputid);
		ArrayList infieldnamelist=DDI.GetInFieldName(datainputid);
		for(int i=0;i<infieldnamelist.size();i++){
            //System.out.println((String)infieldnamelist.get(i)+"|"+Util.null2String(request.getParameter(datainputid+"|"+(String)infieldnamelist.get(i))));
			//DDI.SetInFields((String)infieldnamelist.get(i),Util.null2String(request.getParameter(datainputid+"|"+(String)infieldnamelist.get(i))));
			DDI.SetInFields((String)infieldnamelist.get(i),Util.null2String(request.getParameter(datainputid+"|"+(String)infieldnamelist.get(i)+"_"+temp)));
		}
		ArrayList conditionfieldnameList=DDI.GetConditionFieldName(datainputid);
		for(int j=0;j<conditionfieldnameList.size();j++){
			//DDI.SetConditonFields((String)conditionfieldnameList.get(j),Util.null2String(request.getParameter(datainputid+"|"+(String)conditionfieldnameList.get(j))));
			DDI.SetConditonFields((String)conditionfieldnameList.get(j),Util.null2String(request.getParameter(datainputid+"|"+(String)conditionfieldnameList.get(j)+"_"+temp)));
		}
        DDI.GetOutData(datainputid);
        outfieldnamelist=DDI.GetOutFieldNameList();
        outdatasList=DDI.GetOutDataList();

       if(DDI.GetIsCycle().equals("1")){   //明细表字段更新
       	for(int i=0;i<outdatasList.size();i++){
       			outdatahash=(Hashtable)outdatasList.get(i);
       		for(int j=0;j<outfieldnamelist.size();j++){
       		    String tempValue = (String)outdatahash.get(outfieldnamelist.get(j));
       		 	tempValue = Util.toExcelData(tempValue);
       		    tempValue = Util.StringReplace(tempValue,";","┌weaver┌");
       		    //tempValue = Util.StringReplace(tempValue,"\"","\\\\\\\"");
       				String js=DDI.ChangeDetailField((String)outfieldnamelist.get(j),tempValue,isbill,nodeid,triggerfieldname,indexid,true);
       				js = Util.StringReplace(js,"&quot；","\\\\\\\"");
       				js = Util.StringReplace(js,"\''", "\'");
       				//js = Util.toHtmlMode(js);
       				//System.out.println("mainjs:"+js);
%>
                    //alert("outdatalist:<%=outdatasList.size()%>");
					//alert("<%=js%>");
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
					window.parent.DataInputByBrowser("<%=outfieldnamelist.get(j)%>_<%=indexid%>");
<%

	        	}
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
/*
if (!!$G("inputcheck", window.parent.document)) {
	$G("inputcheck", window.parent.document).value = $G("inputcheck", window.parent.document).value + "<%=inputchecks%>";
}
*/
window.parent.frmmain.ChinaExcel.RefreshViewSize();    
try{window.parent.frmmain.ChinaExcel.ReCalculate();}catch(e1){}
try{window.parent.frmmain.ChinaExcel.RefreshViewSize();}catch(e2){}
}

</script>