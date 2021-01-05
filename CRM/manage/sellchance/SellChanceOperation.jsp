
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.docs.*" %>
<%@ page import="weaver.docs.docs.*" %>
<%@ page import="weaver.conn.*" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSetM" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="SysRemindWorkflow" class="weaver.system.SysRemindWorkflow" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page" />
<%
char flag=2;
String para="";
String method = request.getParameter("method");

String frombase =  Util.null2String(request.getParameter("frombase"));
String chanceid = Util.null2String(request.getParameter("chanceid"));//当edit和delete时候有值
String subject = request.getParameter("subject");
String Creater = Util.null2String(request.getParameter("Creater"));
String CustomerID = Util.null2String(request.getParameter("customer"));
String Comefrom =Util.null2String(request.getParameter("Comefrom"));
String sellstatusid =Util.null2String(request.getParameter("sellstatusid"));
String endtatusid =Util.null2String(request.getParameter("endtatusid"));
String preselldate =Util.null2String(request.getParameter("preselldate"));
String preyield =Util.null2String(request.getParameter("preyield"));
String probability =Util.null2String(request.getParameter("probability"));
String content =Util.null2String(request.getParameter("Agent"));
boolean isfromtab =  Util.null2String(request.getParameter("isfromtab")).equals("true")?true:false;
if(content.trim().equals(""))content="0";

String sufactorid =Util.null2String(request.getParameter("sufactorid"));//成功关键因素
String defactorid =Util.null2String(request.getParameter("defactorid"));//失败关键因素

String departmentId = ResourceComInfo.getDepartmentID(Creater);//客户经理的部门ID
String subCompanyId = DepartmentComInfo.getSubcompanyid1(departmentId);//客户经理的分部ID

String selltype =Util.null2String(request.getParameter("selltype"));//销售类型

String currencyid="";
if(preyield.equals("")) preyield="0";
if(probability.equals("")) probability="0";
int rownum = Util.getIntValue(request.getParameter("rownum"),user.getLanguage()) ;//行数

Calendar today = Calendar.getInstance();
String currentdate = Util.add0(today.get(Calendar.YEAR), 4) +"-"+
                     Util.add0(today.get(Calendar.MONTH) + 1, 2) +"-"+
                     Util.add0(today.get(Calendar.DAY_OF_MONTH), 2) ;
Calendar now = Calendar.getInstance();
String currenttime = Util.add0(now.getTime().getHours(), 2) +":"+
                     Util.add0(now.getTime().getMinutes(), 2) +":"+
                     Util.add0(now.getTime().getSeconds(), 2) ;

 
//以下是给相应的人员触发工作流
/*=================================================*/
String CurrentUser = ""+user.getUID();
String CurrentUserName = ""+user.getUsername();


String SWFAccepter="";
String SWFTitle="";
String SWFRemark="";
String SWFSubmiter="";
String Subject="";

String thesql="select managerid from HrmResource where id = "+CurrentUser;
RecordSetM.executeSql(thesql);
RecordSetM.next();
String managerid=RecordSetM.getString("managerid"); //通知上级
/*================================================*/


if(method.equals("add")){

    if(rownum==0){
        currencyid = "1";
    }//货币单位默认为"1"
    else{
        currencyid = Util.fromScreen(request.getParameter("currencyid_"+0),user.getLanguage());
    }//通过第一行的货币单位来设置货币单位
    para= ""+Creater;
    para += flag + subject;
    para += flag + CustomerID;
    para += flag + Comefrom;
    para += flag + sellstatusid; 
    para += flag + endtatusid;
    para += flag + preselldate;
    para += flag + preyield;
    para += flag + currencyid;
    para += flag + probability;
    para += flag + currentdate;
    para += flag + currenttime;
    para += flag + content;
    para += flag + sufactorid;
    para += flag + defactorid;
    
	para += flag + departmentId;
	para += flag + subCompanyId;
	para += flag + selltype;	
		
    rs.executeProc("CRM_SellChance_insert",para);  

    rs.executeProc("CRM_SellChance_SMAXID","");  
    rs.next();
    String sellchanceid = rs.getString("sellchanceid");

    if(!sellchanceid.equals("0")){    
        for(int i = 0;i<rownum;i++){
        String productid = Util.fromScreen(request.getParameter("productname_"+i),user.getLanguage());
        String assetunitid = Util.fromScreen(request.getParameter("assetunitid_"+i),user.getLanguage());
               currencyid = Util.fromScreen(request.getParameter("currencyid_"+i),user.getLanguage());
        String salesprice = Util.fromScreen(request.getParameter("salesprice_"+i),user.getLanguage());
        String salesnum = Util.fromScreen(request.getParameter("number_"+i),user.getLanguage());
        String totelprice =Util.fromScreen(request.getParameter("totelprice_"+i),user.getLanguage()); 
        String info = productid+assetunitid+currencyid+salesprice+salesnum+totelprice;
        if(!info.trim().equals("")){
        para = ""+sellchanceid+flag+productid+flag+assetunitid+flag+currencyid+flag+salesprice+flag+salesnum+flag+totelprice;
        rs.executeProc("CRM_ProductTable_insert",para);  
        }
        }
        
        //增加跟进信息
        if(selltype.equals("1")){
        	String rownumber = "";
        	int rowcount = 0;
        	for(int i=1;i<5;i++){
        		rownumber = Util.fromScreen3(request.getParameter("rownum"+i),user.getLanguage());
        		rowcount = 0;
        	    if(rownumber != null && !"".equals(rownumber)){
        	    	rowcount = Integer.parseInt(rownumber);
        	    }
        	    for(int j=0;j<rowcount;j++){
        	        String item = Util.fromScreen3(request.getParameter("item"+i+"_"+j),user.getLanguage());
        	        if(!"".equals(item)){
        	        	String desc = Util.fromScreen3(request.getParameter("desc"+i+"_"+j),user.getLanguage());
            	        if(i==4){
            	        	String fileIds_ = Util.fromScreen(request.getParameter("relatedacc_"+j),user.getLanguage());
                			fileIds_ = cutString(fileIds_,",",3);
                			   
                			String newrelatedacc_ =Util.fromScreen(request.getParameter("newrelatedacc_"+j),user.getLanguage());  //新添加相关附件id
                			newrelatedacc_ = cutString(newrelatedacc_,",",3);
                			
                			fileIds_ = fileIds_ + "," + newrelatedacc_;//新附件id
                			desc = cutString(fileIds_,",",3);
            	        }
        	        	//保存记录
        				rs.executeSql("insert into CRM_SellChance_Info (sellchanceId,infotype,name,description) values("+sellchanceid+","+i+",'"+item+"','"+desc+"')");
        	        }
        	  	}
        	}
        }
    }

if(!CurrentUser.equals(managerid)){//上级经理是本人，就不要触发工作流

/*添加客户销售机会触发工作流*/
    Subject=SystemEnv.getHtmlLabelName(15249,user.getLanguage());
    Subject+=":"+subject;

    SWFAccepter=managerid;
    SWFTitle=SystemEnv.getHtmlLabelName(15249,user.getLanguage());
    SWFTitle += ":"+subject;
    SWFTitle += "-"+CurrentUserName;
    SWFTitle += "-"+currentdate;
    SWFRemark="<a href=/CRM/sellchance/ViewSellChance.jsp?id="+sellchanceid+"&CustomerID="+CustomerID+">"+Util.fromScreen2(Subject,user.getLanguage())+"</a>";
    SWFSubmiter=CurrentUser;

    SysRemindWorkflow.setCRMSysRemind(SWFTitle,Util.getIntValue(CustomerID),Util.getIntValue(SWFSubmiter),SWFAccepter,SWFRemark);	
/*workflow _ end*/
}
if(frombase.equals("1")){
%>
	<script type="text/javascript">
		if(opener != null && opener.onRefresh != null){opener.onRefresh();}
		window.location="/CRM/sellchance/ViewSellChance.jsp?id=<%=sellchanceid%>&CustomerID=<%=CustomerID%>&frombase=<%=frombase%>";
	</script>
<%
}else{
	response.sendRedirect("/CRM/sellchance/ListSellChance.jsp?isfromtab="+isfromtab+"&CustomerID="+CustomerID);
}
}


if(method.equals("edit")){

    if(rownum==0){
        currencyid = "1";
    }//货币单位默认为"1"
    else{
        currencyid = Util.fromScreen(request.getParameter("currencyid_"+0),user.getLanguage());
    }//通过第一行的货币单位来设置货币单位
    para= ""+Creater;
    para += flag + subject;
    para += flag + CustomerID;
    para += flag + Comefrom;
    para += flag + sellstatusid; 
    para += flag + endtatusid;
    para += flag + preselldate;
    para += flag + preyield;
    para += flag + currencyid;
    para += flag + probability;
    para += flag + content;
    para += flag + chanceid;//比insert多一个参数
    para += flag + sufactorid;
    para += flag + defactorid;

	para += flag + departmentId;
	para += flag + subCompanyId;
	para += flag + selltype;
		
    rs.executeProc("CRM_SellChance_Update",para);
    
    //对于产品表，先删除原先的，再做insert即可
    rs.executeProc("CRM_Product_Delete",chanceid);
    for(int i = 0;i<rownum;i++){
        String productid = Util.fromScreen(request.getParameter("productname_"+i),user.getLanguage());
        String assetunitid = Util.fromScreen(request.getParameter("assetunitid_"+i),user.getLanguage());
               currencyid = Util.fromScreen(request.getParameter("currencyid_"+i),user.getLanguage());
        String salesprice = Util.fromScreen(request.getParameter("salesprice_"+i),user.getLanguage());
        String salesnum = Util.fromScreen(request.getParameter("number_"+i),user.getLanguage());
        String totelprice =Util.fromScreen(request.getParameter("totelprice_"+i),user.getLanguage()); 
        String info = productid+assetunitid+currencyid+salesprice+salesnum+totelprice;
        if(!info.trim().equals("")){
        para = ""+chanceid+flag+productid+flag+assetunitid+flag+currencyid+flag+salesprice+flag+salesnum+flag+totelprice;
        rs.executeProc("CRM_ProductTable_insert",para);  
        }
    }
    
  	//增加跟进信息
  	//删除新签类型变为二次类型时删除原附件文档 
  	if(selltype.equals("2")){
  		rs.executeSql("select description from CRM_SellChance_Info where infotype=4 and sellchanceId ="+chanceid);
  		while(rs.next()){
  			String _flleIds = Util.null2String(rs.getString("description"));
  			//删除相关附件
			if(!"".equals(_flleIds)){
				deleteDoc(_flleIds,user,request.getRemoteAddr());
			}
  		}
  	}
  	rs.executeSql("delete from CRM_SellChance_Info where sellchanceId ="+chanceid);
    if(selltype.equals("1")){
    	String rownumber = "";
    	int rowcount = 0;
    	for(int i=1;i<5;i++){
    		rownumber = Util.fromScreen3(request.getParameter("rownum"+i),user.getLanguage());
    		rowcount = 0;
    	    if(rownumber != null && !"".equals(rownumber)){
    	    	rowcount = Integer.parseInt(rownumber);
    	    }
    	    for(int j=0;j<rowcount;j++){
    	        String item = Util.fromScreen3(request.getParameter("item"+i+"_"+j),user.getLanguage());
    	        if(!"".equals(item)){
    	        	String desc = Util.fromScreen3(request.getParameter("desc"+i+"_"+j),user.getLanguage());
        	        if(i==4){
        	        	String fileIds_ = Util.fromScreen(request.getParameter("relatedacc_"+j),user.getLanguage());
            			fileIds_ = cutString(fileIds_,",",3);
            			   
            			String delrelatedacc_ =Util.fromScreen(request.getParameter("delrelatedacc_"+j),user.getLanguage());  //删除相关附件id
            			
            			String newrelatedacc_ =Util.fromScreen(request.getParameter("newrelatedacc_"+j),user.getLanguage());  //新添加相关附件id
            			newrelatedacc_ = cutString(newrelatedacc_,",",3);
            			
            			fileIds_ = fileIds_ + "," + newrelatedacc_;//新附件id
            			desc = cutString(fileIds_,",",3);
            			
            			//删除相关附件
            			if(!"".equals(delrelatedacc_)){
            				deleteDoc(delrelatedacc_.substring(0,delrelatedacc_.length()-1),user,request.getRemoteAddr());
            			}
            				
        	        }
    	        	//保存记录
    				rs.executeSql("insert into CRM_SellChance_Info (sellchanceId,infotype,name,description) values("+chanceid+","+i+",'"+item+"','"+desc+"')");
    	        }
    	  	}
    	}
    }

  
 if(!CurrentUser.equals(managerid)){//上级经理是本人，就不要触发工作流

/*编辑客户销售机会触发工作流*/
    Subject=SystemEnv.getHtmlLabelName(15250,user.getLanguage());
    Subject+=":"+subject;

    SWFAccepter=managerid;
    SWFTitle=SystemEnv.getHtmlLabelName(15250,user.getLanguage());
    SWFTitle += ":"+subject;
    SWFTitle += "-"+CurrentUserName;
    SWFTitle += "-"+currentdate;
    SWFRemark="<a href=/CRM/sellchance/ViewSellChance.jsp?id="+chanceid+"&CustomerID="+CustomerID+">"+Util.fromScreen2(Subject,user.getLanguage())+"</a>";
    SWFSubmiter=CurrentUser;
    SysRemindWorkflow.setCRMSysRemind(SWFTitle,Util.getIntValue(CustomerID),Util.getIntValue(SWFSubmiter),SWFAccepter,SWFRemark);	
/*workflow _ end*/    
 }
if(frombase.equals("1")){
	 %>
	 	<script type="text/javascript">
	 		if(opener != null && opener.onRefresh != null){opener.onRefresh();}
	 		window.location="/CRM/sellchance/ViewSellChance.jsp?id=<%=chanceid%>&CustomerID=<%=CustomerID%>&frombase=<%=frombase%>";
	 	</script>
	 <%
}else{
	response.sendRedirect("/CRM/sellchance/ViewSellChance.jsp?id="+chanceid+"&CustomerID="+CustomerID+"&frombase="+frombase);
}
}
if(method.equals("del")){
    rs.executeProc("CRM_SellChance_Delete",chanceid);
    rs.executeProc("CRM_Product_Delete",chanceid);
  	rs.executeSql("select description from CRM_SellChance_Info where infotype=4 and sellchanceId ="+chanceid);
  	while(rs.next()){
  		String _flleIds = Util.null2String(rs.getString("description"));
  		//删除相关附件
		if(!"".equals(_flleIds)){
			deleteDoc(_flleIds,user,request.getRemoteAddr());
		}
  	}
  	rs.executeSql("delete from CRM_SellChance_Info where sellchanceId ="+chanceid);
  	if(frombase.equals("1")){
  		 %>
  		 	<script type="text/javascript">if(opener != null && opener.onRefresh != null){opener.onRefresh();}window.close();</script>
  		 <%
  	}else{
  		response.sendRedirect("/CRM/sellchance/ListSellChance.jsp?CustomerID="+CustomerID+"");
  	}
}
if(method.equals("reopen")){
	String sqlStr = "Update CRM_SellChance set endtatusid = 0 where id = " + chanceid;
	RecordSet.executeSql(sqlStr);
	if(frombase.equals("1")){
%>
		 	<script type="text/javascript">
		 		if(opener != null && opener.onRefresh != null){opener.onRefresh();}
		 		window.location="/CRM/sellchance/ViewSellChance.jsp?id=<%=chanceid%>&CustomerID=<%=CustomerID%>&frombase=<%=frombase%>";
		 	</script>
<%}else{
		response.sendRedirect("/CRM/sellchance/ViewSellChance.jsp?id="+chanceid+"&CustomerID="+CustomerID+"&frombase="+frombase);
	}
}
%>
<%!
public String cutString(String str,String temp,int type){
	str = Util.null2String(str);
	temp = Util.null2String(temp);
	if(str.equals("") || temp.equals("")){
		return str;
	}
	if(type == 1 || type == 3){
		if(str.startsWith(temp)){
			str = str.substring(temp.length());
		}
	}
	if(type == 2 || type == 3){
		if(str.endsWith(temp)){
			str = str.substring(0,str.length()-temp.length());
		}
	}
	return str;
}
private void deleteDoc(String docIds,User user,String ip){
	DocDetailLog docDetailLog = new DocDetailLog();
	DocExtUtil deu = new DocExtUtil();
	RecordSet rs = new RecordSet();
	if(!"".equals(docIds)){
		rs.executeSql("select * from DocDetail where id in (" + docIds + ")");
	    while(rs.next()) {
			String docid = Util.null2String(rs.getString("id"));
			String docsubject = Util.null2String(rs.getString("docsubject"));
			String doccreaterid =  Util.null2String(rs.getString("doccreaterid"));
			String doccreatertype = Util.null2String(rs.getString("doccreatertype"));
			try {
				deu.deleteDoc(Util.getIntValue(docid));
				docDetailLog.resetParameter();
				docDetailLog.setDocId(Util.getIntValue(docid));
				docDetailLog.setDocSubject(docsubject);
				docDetailLog.setOperateType("3");           
				docDetailLog.setOperateUserid(user.getUID());
				docDetailLog.setUsertype(user.getLogintype());
				docDetailLog.setClientAddress(ip);
				docDetailLog.setDocCreater(Util.getIntValue(doccreaterid,0));
				docDetailLog.setCreatertype(doccreatertype);
				docDetailLog.setDocLogInfo();
			}catch(Exception e){
			}
	    }
	}
}
%>