<%@page import="weaver.conn.aop.RecordSetTransAop"%>
<%@page import="weaver.conn.RecordSet"%>
<%@page import="weaver.conn.RecordSetTrans"%>

<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util"%>
<%@ page import="weaver.system.code.*"%>
<%@ page import="weaver.general.BaseBean" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<%
boolean canEdit=true;
if(!HrmUserVarify.checkUserRight("CapitalCodingSet:All", user)){
	response.sendRedirect("/notice/noright.jsp");
    return;
}
%>
<%
  String sql = "";
  String datatype=  Util.null2String(request.getParameter("datatype"));
  boolean isData1=datatype.equalsIgnoreCase("data1");
  
  String postValue=  Util.null2String(request.getParameter("postValue"));
  
  String codeid = Util.null2String(request.getParameter("codeid"));
  int isuse=  Util.getIntValue(request.getParameter("isuse"),0);
  String subcompanyflow = Util.null2String(request.getParameter("subcompanyflow"));
  String departmentflow = Util.null2String(request.getParameter("departmentflow"));
  String capitalgroupflow = Util.null2String(request.getParameter("capitalgroupflow"));
  String capitaltypeflow = Util.null2String(request.getParameter("capitaltypeflow"));
  String buydate = Util.null2String(request.getParameter("buydate"));
  String buydateselect = Util.null2String(request.getParameter("buydateselect"));
  String Warehousing = Util.null2String(request.getParameter("Warehousing"));
  String Warehousingselect = Util.null2String(request.getParameter("Warehousingselect"));
  String assetdataflow = Util.null2String(request.getParameter("assetdataflow"));
  if(buydate.equals("")) buydate = "0";
  if(Warehousing.equals("")) Warehousing = "0";
  String buydateflow = buydate + "|" + buydateselect; 
  String Warehousingflow = Warehousing + "|" + Warehousingselect;  
  String startcodenum = Util.null2String(request.getParameter("startcodenum"));
  String changecode = Util.null2String(request.getParameter("changecode"));
  
  sql = "select * from "+(isData1?" cptcode1 ":" cptcode ")+" where id = " + codeid;

  rs.executeSql(sql);
    if (rs.next())
    {
     sql = "update  "+(isData1?" cptcode1 ":" cptcode ")+"  set isuse='"+isuse+"',subcompanyflow='"+subcompanyflow+"',departmentflow='"+departmentflow+"',capitalgroupflow='"+capitalgroupflow+"',capitaltypeflow='"+capitaltypeflow+"',buydateflow='"+buydateflow+"',Warehousingflow='"+Warehousingflow+"',startcodenum='"+startcodenum+"',assetdataflow='"+assetdataflow+"' where id = " + codeid;
     rs.executeSql(sql);
    }
    else
    {
  //   sql = "insert into  "+(isData1?" cptcode1 ":" cptcode ")+" (isuse,subcompanyflow,departmentflow,capitalgroupflow,capitaltypeflow,buydateflow,Warehousingflow,startcodenum,assetdataflow) values("+isuse+",'"+subcompanyflow+"','"+departmentflow+"','"+capitalgroupflow+"','"+capitaltypeflow+"','"+buydateflow+"','"+Warehousingflow+"','"+startcodenum+"','"+assetdataflow+"')";
   //  rs.executeSql(sql);
    }
    
	//sql = "delete from "+(isData1?" cptcodeset1 ":" cptcodeset ")+" where codeid = " + codeid;
	//rs.executeSql(sql);
    String[] members = Util.TokenizerString2(postValue,"\u0007");
    for (int i=0;i<members.length;i++){
      String member = members[i];
      String memberAttibutes[] = Util.TokenizerString2(member,"\u001b");
      String text = memberAttibutes[0];
      String value = memberAttibutes[1];
      if ("[(*_*)]".equals(value)){value="";}
      String type = memberAttibutes[2];
	
      //String insertStr = "insert into "+(isData1?" cptcodeset1 ":" cptcodeset ")+"(codeid,showname,showtype,value,codeorder) values ('"+codeid+"','"+text+"','"+type+"','"+value+"','"+i+"')";	  
      String insertStr = "update "+(isData1?" cptcodeset1 ":" cptcodeset ")+"set value='"+value+"',codeorder='"+i+"',showtype='"+type+"' where showname='"+text+"' and codeid='"+codeid+"' ";	  
      
      rs.executeSql(insertStr);
    }

	if(changecode.equals("1")){
		if(startcodenum.equals("")) startcodenum = "0";
		sql = "update   "+(isData1?" cptcapitalcodeseq1 ":" cptcapitalcodeseq ")+" set sequenceid = " + startcodenum + " where sequenceid < '"+startcodenum+"'";
		
		rs.executeSql(sql);
	} 
	  

     response.sendRedirect((isData1?"CapitalCodingData1.jsp":"CapitalCoding.jsp"));

%>


