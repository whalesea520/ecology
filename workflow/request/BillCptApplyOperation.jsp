<%@page import="com.weaver.formmodel.util.DateHelper"%>
<%@ page import="weaver.general.Util"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="RequestManager" class="weaver.workflow.request.RequestManager" scope="page"/>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="RecordSet1" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="RecordSetInner" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="CapitalComInfo" class="weaver.cpt.capital.CapitalComInfo" scope="page"/>
<jsp:useBean id="CapitalAssortmentComInfo" class="weaver.cpt.maintenance.CapitalAssortmentComInfo" scope="page" />
<jsp:useBean id="CptShare" class="weaver.cpt.capital.CptShare" scope="page" />
<jsp:useBean id="PoppupRemindInfoUtil" class="weaver.workflow.msg.PoppupRemindInfoUtil" scope="page"/>
<jsp:useBean id="CodeBuild" class="weaver.system.code.CodeBuild" scope="page"/>
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page"/>
<jsp:useBean id="WFManager" class="weaver.workflow.workflow.WFManager" scope="page"/>
<jsp:useBean id="CptDwrUtil" class="weaver.cpt.util.CptDwrUtil" scope="page"/>
<jsp:useBean id="RequestInfo" class="weaver.soa.workflow.request.RequestInfo" scope="page"/>

<%@ page import="weaver.file.FileUpload" %>
<%
FileUpload fu = new FileUpload(request);
String f_weaver_belongto_userid=fu.getParameter("f_weaver_belongto_userid");
String f_weaver_belongto_usertype=fu.getParameter("f_weaver_belongto_usertype");
user = HrmUserVarify.getUser(request, response, f_weaver_belongto_userid, f_weaver_belongto_usertype) ;
String src = Util.null2String(fu.getParameter("src"));
String iscreate = Util.null2String(fu.getParameter("iscreate"));
int requestid = Util.getIntValue(fu.getParameter("requestid"),-1);
int workflowid = Util.getIntValue(fu.getParameter("workflowid"),-1);
String workflowtype = Util.null2String(fu.getParameter("workflowtype"));
int isremark = Util.getIntValue(fu.getParameter("isremark"),-1);
int formid = Util.getIntValue(fu.getParameter("formid"),-1);
int isbill = Util.getIntValue(fu.getParameter("isbill"),-1);
int billid = Util.getIntValue(fu.getParameter("billid"),-1);
int nodeid = Util.getIntValue(fu.getParameter("nodeid"),-1);
String nodetype = Util.null2String(fu.getParameter("nodetype"));
String requestname = Util.fromScreen(fu.getParameter("requestname"),user.getLanguage());
String requestlevel = Util.fromScreen(fu.getParameter("requestlevel"),user.getLanguage());
String messageType =  Util.fromScreen(fu.getParameter("messageType"),user.getLanguage());
String remark = Util.null2String(fu.getParameter("remark"));
String chatsType =  Util.fromScreen(fu.getParameter("chatsType"),user.getLanguage());
String[] check_node_vals = fu.getParameterValues("check_node_val");
if( src.equals("") || workflowid == -1 || formid == -1 || isbill == -1 || nodeid == -1 || nodetype.equals("") ) {
    //response.sendRedirect("/notice/RequestError.jsp");
    out.print("<script>wfforward('/notice/RequestError.jsp');</script>");
    return ;
}



RequestManager.setSrc(src) ;
RequestManager.setIscreate(iscreate) ;
RequestManager.setRequestid(requestid) ;
RequestManager.setWorkflowid(workflowid) ;
RequestManager.setWorkflowtype(workflowtype) ;
RequestManager.setIsremark(isremark) ;
RequestManager.setFormid(formid) ;
RequestManager.setIsbill(isbill) ;
RequestManager.setBillid(billid) ;
RequestManager.setNodeid(nodeid) ;
RequestManager.setNodetype(nodetype) ;
RequestManager.setRequestname(requestname) ;
RequestManager.setRequestlevel(requestlevel) ;
RequestManager.setRemark(remark) ;
RequestManager.setRequest(fu) ;
RequestManager.setUser(user) ;
RequestManager.setChatsType(chatsType) ;
//add by chengfeng.han 2011-7-28 td20647 
int isagentCreater = Util.getIntValue((String)session.getAttribute(workflowid+"isagent"+user.getUID()));
int beagenter = Util.getIntValue((String)session.getAttribute(workflowid+"beagenter"+user.getUID()),0);
RequestManager.setIsagentCreater(isagentCreater);
RequestManager.setBeAgenter(beagenter);
//end
//add by xhheng @ 2005/01/24 for 消息提醒 Request06
RequestManager.setMessageType(messageType) ;

boolean savestatus = RequestManager.saveRequestInfo() ;
requestid = RequestManager.getRequestid() ;
if( !savestatus ) {
    if( requestid != 0 ) {

        String message=RequestManager.getMessage();
        if(!"".equals(message)){
        	out.print("<script>wfforward('/workflow/request/ViewRequest.jsp?f_weaver_belongto_userid="+user.getUID()+"&f_weaver_belongto_usertype="+f_weaver_belongto_usertype+"&f_weaver_belongto_userid="+user.getUID()+"&f_weaver_belongto_usertype="+f_weaver_belongto_usertype+"&requestid="+requestid+"&message="+message+"');</script>");
            return ;
        }
        //response.sendRedirect("/workflow/request/ManageRequest.jsp?requestid="+requestid+"&message=1");
        out.print("<script>wfforward('/workflow/request/ManageRequest.jsp?f_weaver_belongto_userid="+user.getUID()+"&f_weaver_belongto_usertype="+f_weaver_belongto_usertype+"&requestid="+requestid+"&message=1');</script>");
        return ;
    }
    else {
        //response.sendRedirect("/workflow/request/RequestView.jsp?message=1");
        out.print("<script>wfforward('/workflow/request/RequestView.jsp?message=1');</script>");
        return ;
    }
}



String ismode="";
RecordSet.executeSql("select ismode,showdes,printdes from workflow_flownode where workflowid="+workflowid+" and nodeid="+nodeid);
if(RecordSet.next()){
    ismode=Util.null2String(RecordSet.getString("ismode"));
}

char flag = 2; 
String updateclause = "" ;
// add record into bill_CptApplyDetail
if( !ismode.equals("1")&&(src.equals("save") || src.equals("submit")) ) {      // 修改细表和主表信息
	if( !iscreate.equals("1") ) RecordSet.executeSql("delete from bill_CptApplyDetail where cptapplyid =" + billid);
    else {
        requestid = RequestManager.getRequestid() ;
        billid = RequestManager.getBillid() ;
    }

	int rowsum = Util.getIntValue(Util.null2String(fu.getParameter("nodesnum")));
	if(ismode.equals("1")){//图形化模式下的取值，只有一个明细组，取nodesnum0
	    rowsum = Util.getIntValue(Util.null2String(fu.getParameter("nodesnum0")));
	}
	float totalamount =0;
	if(check_node_vals != null && check_node_vals.length>0){
		
		for(int i=0;i<check_node_vals.length;i++) {		
		String idval = check_node_vals[i];
		int cpttypeid = Util.getIntValue(Util.null2String(fu.getParameter("node_"+idval+"_cpttypeid")),0);
		int cptid = Util.getIntValue(Util.null2String(fu.getParameter("node_"+idval+"_cptid")),0);
		int cptcapitalid = Util.getIntValue(Util.null2String(fu.getParameter("node_"+idval+"_cptcapitalid")),0);
		float number = Util.getFloatValue(fu.getParameter("node_"+idval+"_number"),-1);
		float unitprice = Util.getFloatValue(fu.getParameter("node_"+idval+"_unitprice"),0);
		
		String needdate = Util.null2String(fu.getParameter("node_"+idval+"_needdate"));
		String purpose = Util.null2String(fu.getParameter("node_"+idval+"_purpose"));
		String cptdesc = Util.null2String(fu.getParameter("node_"+idval+"_cptdesc"));
			String cptspec = Util.null2String(fu.getParameter("node_"+idval+"_cptspec"));
		
			if(number == -1){
				number = 0;
			}
			//if(number <=0 ) continue ;
		float amount = number * unitprice;
		
			String para = ""+billid+flag+cpttypeid+flag+cptid+flag+number+flag+unitprice+flag + amount+flag+needdate+flag+purpose+flag+cptdesc+flag+cptcapitalid+flag+cptspec;
			RecordSet.executeProc("bill_CptApplyDetail_Insert2",para);
		totalamount += amount;		
		}	
	}
	updateclause = " set totalamount = "+totalamount+" ";
	updateclause="update bill_CptApplyMain "+updateclause+" where id = "+billid;
	RecordSet.executeSql(updateclause);

}

   

//判断入库数是否是否会超过库存
if (!ismode.equals("1")) {
if(check_node_vals!=null && check_node_vals.length>0){
	for(int i=0;i<check_node_vals.length;i++) {
	String idval1 = check_node_vals[i];
	String cpttype1 = Util.null2String(fu.getParameter("node_"+idval1+"_cptid"));//资产资料
	String plannumber1 = Util.null2String(fu.getParameter("node_"+idval1+"_number"));//数量
	if(Util.getIntValue(cpttype1,0)<=0||Util.getDoubleValue(plannumber1)<=0){
		continue;
	}
	
	String StockInDate_dtl1 = Util.null2String(fu.getParameter("node_"+idval1+"_needdate"));//购置日期
	String capitalspec1 = Util.null2String(fu.getParameter("node_"+idval1+"_cptspec"));//规格型号
	
	String sptcount11="";//sptcount1为1表示单独核算
	String capitalgroupid11 ="";
	String capitaltypeid11 ="";
	RecordSet.executeProc("CptCapital_SelectByID",cpttype1);

if(RecordSet.next()){
	sptcount11 = RecordSet.getString("sptcount");
	capitalgroupid11 = RecordSet.getString("capitalgroupid");
	capitaltypeid11 = RecordSet.getString("capitaltypeid");
}
  

String departmentid21 = Util.fromScreen(fu.getParameter("field153"),user.getLanguage());  //部门 用来测试流水号
	if(sptcount11.equals("1")){
	  plannumber1 = (int)Util.getFloatValue(plannumber1,0) + "";
	  
	  String isover1 = "";		                     
       		      
        isover1 =CodeBuild.getCurrentCapitalCodeIsOver(DepartmentComInfo.getSubcompanyid1(departmentid21),departmentid21,capitalgroupid11,capitaltypeid11,StockInDate_dtl1,StockInDate_dtl1,cpttype1,(int)Util.getFloatValue(plannumber1,0));
     	if ("yes".equals(isover1)) {    		     		
     		RecordSet.executeSql("select name from cptcapital where isdata = 1 and id = "+cpttype1);
     		RecordSet.next();
     		String namezc1 = Util.null2String(RecordSet.getString(1));
     	    String ss1= namezc1+" 流水号位数已超过使用限制,请重新设置编码规则!";	
     	   
           if(!"".equals(ss1)){
        	   RequestManager.setMessagecontent(ss1);
           	   out.print("<script>wfforward('/workflow/request/ViewRequest.jsp?f_weaver_belongto_userid="+user.getUID()+"&f_weaver_belongto_usertype="+f_weaver_belongto_usertype+"&f_weaver_belongto_userid="+user.getUID()+"&f_weaver_belongto_usertype="+f_weaver_belongto_usertype+"&requestid="+requestid+"&message=126221');</script>");
               return ;
           }	      	     	    
		} 		
	}else{		
	        String isover1 = "";		                     
	         // 判断流水位数是否会超出 add by wangxp			      
	        isover1 =CodeBuild.getCurrentCapitalCodeIsOver(DepartmentComInfo.getSubcompanyid1(departmentid21),departmentid21,capitalgroupid11,capitaltypeid11,StockInDate_dtl1,StockInDate_dtl1,cpttype1,1);
	     	if ("yes".equals(isover1)) {  
                RecordSet.executeSql("select name from cptcapital where isdata = 1 and id = "+cpttype1);
	     		RecordSet.next();
	     		String namezc1 = Util.null2String(RecordSet.getString(1));
	     		String ss1= namezc1+" 流水号位数已超过使用限制,请重新设置编码规则!";
	     		
	            if(!"".equals(ss1)){
	                RequestManager.setMessagecontent(ss1);
	            	out.print("<script>wfforward('/workflow/request/ViewRequest.jsp?f_weaver_belongto_userid="+user.getUID()+"&f_weaver_belongto_usertype="+f_weaver_belongto_usertype+"&f_weaver_belongto_userid="+user.getUID()+"&f_weaver_belongto_usertype="+f_weaver_belongto_usertype+"&requestid="+requestid+"&message=126221');</script>");
	                return ;
	            }	                 
			}
	}
}
}  
}
	
boolean flowstatus = RequestManager.flowNextNode() ;
if( !flowstatus ) {
	//response.sendRedirect("/workflow/request/ManageRequest.jsp?requestid="+requestid+"&message=2");
	out.print("<script>wfforward('/workflow/request/ManageRequest.jsp?f_weaver_belongto_userid="+user.getUID()+"&f_weaver_belongto_usertype="+f_weaver_belongto_usertype+"&requestid="+requestid+"&message=2');</script>");
	return ;
}

//审批通过后到归档节点，更新资产表。功能相当于：资产管理-〉资产管理-〉入库验收 ==开始==
//System.out.println("src=="+src);
//System.out.println("RequestManager.getNextNodetype()=="+RequestManager.getNextNodetype());

if(src.equals("submit")&&RequestManager.getNextNodetype().equals("3")){
	String BuyerID = Util.fromScreen(fu.getParameter("field154"),user.getLanguage());//申购人id
	String CheckerID = Util.fromScreen(""+user.getUID(),user.getLanguage());//验收人id
	String StockInDate = "";//入库日期YYYY-MM-DD
	Calendar today = Calendar.getInstance();
	StockInDate = Util.add0(today.get(Calendar.YEAR), 4) + "-" +
                Util.add0(today.get(Calendar.MONTH) + 1, 2) + "-" +
                Util.add0(today.get(Calendar.DAY_OF_MONTH), 2);
	String currenttime = Util.add0(today.getTime().getHours(), 2) +":"+
                     	 Util.add0(today.getTime().getMinutes(), 2) +":"+
                       Util.add0(today.getTime().getSeconds(), 2) ;
	char separator = Util.getSeparator() ;
	String para = "";
  para +=separator+BuyerID;
  para +=separator+"";
  para +=separator+CheckerID;
  para +=separator+StockInDate;
	para +=separator+"1";
  RecordSet.executeProc("CptStockInMain_Insert",para);
  
  RecordSet.next();
	String cptstockinid=""+RecordSet.getInt(1);
	
	int rowsum = Util.getIntValue(Util.null2String(fu.getParameter("nodesnum")));
	if(ismode.equals("1")){//图形化模式下的取值，只有一个明细组，取nodesnum0
	    rowsum = Util.getIntValue(Util.null2String(fu.getParameter("nodesnum0")));
	}
	if (!ismode.equals("1")) {
	if(check_node_vals!=null && check_node_vals.length>0){
		for(int i=0;i<check_node_vals.length;i++) {
		String idval = check_node_vals[i];
		String cpttype = Util.null2String(fu.getParameter("node_"+idval+"_cptid"));//资产资料
		String plannumber = Util.null2String(fu.getParameter("node_"+idval+"_number"));//数量
		if(Util.getIntValue(cpttype,0)<=0||Util.getDoubleValue(plannumber)<=0){
			continue;
		}
		String price = Util.null2String(fu.getParameter("node_"+idval+"_unitprice"));//单价
		String customerid_dtl = "";//供应商,流程中没有此字段
		String StockInDate_dtl = Util.null2String(fu.getParameter("node_"+idval+"_needdate"));//购置日期
		String capitalspec = Util.null2String(fu.getParameter("node_"+idval+"_cptspec"));//规格型号
		String location = "";//存放地点,流程中没有此字段
		String Invoice = "";//发票号,流程中没有此字段
		

		String sptcount1="";//sptcount1为1表示单独核算
		String capitalgroupid1 ="";
		String capitaltypeid1 ="";
		RecordSet.executeProc("CptCapital_SelectByID",cpttype);
		
    if(RecordSet.next()){
    	sptcount1 = RecordSet.getString("sptcount");
    	capitalgroupid1 = RecordSet.getString("capitalgroupid");
		capitaltypeid1 = RecordSet.getString("capitaltypeid");
    }
      
    String departmentid2 = Util.fromScreen(fu.getParameter("field153"),user.getLanguage());  //部门 用来测试流水号
		if(sptcount1.equals("1")){
		  plannumber = (int)Util.getFloatValue(plannumber,0) + "";
		  
		  String isover = "";		                     
	       // 判断流水位数是否会超出 add by wangxp			      
	       // isover =CodeBuild.getCurrentCapitalCodeIsOver(DepartmentComInfo.getSubcompanyid1(departmentid2),departmentid2,capitalgroupid1,capitaltypeid1,StockInDate_dtl,StockInDate_dtl,cpttype,(int)Util.getFloatValue(plannumber,0));
	        
	     	
				  for (int j=0;j<Util.getIntValue(plannumber,0);j++){//单独核算根据实际入库的数量每个资产单独为一条记录
						para = cptstockinid;
						para +=separator+cpttype;
						para +=separator+"1";//计划入库数量
						para +=separator+"1";//实际入库数量
						para +=separator+price;
					    para +=separator+customerid_dtl;
					    para +=separator+StockInDate_dtl;
					    para +=separator+capitalspec;
					    para +=separator+location;
					    para +=separator+Invoice;
						RecordSet.executeProc("CptStockInDetail_Insert",para);
					}
			
			  		
		}else{
			para = cptstockinid;
			para +=separator+cpttype;
			para +=separator+plannumber;//计划入库数量
			para +=separator+plannumber;//实际入库数量
			para +=separator+price;
		    para +=separator+customerid_dtl;
		    para +=separator+StockInDate_dtl;
		    para +=separator+capitalspec;
		    para +=separator+location;
		    para +=separator+Invoice;

		        String isover = "";		                     
		       // 判断流水位数是否会超出 add by wangxp			      
		        //isover =CodeBuild.getCurrentCapitalCodeIsOver(DepartmentComInfo.getSubcompanyid1(departmentid2),departmentid2,capitalgroupid1,capitaltypeid1,StockInDate_dtl,StockInDate_dtl,cpttype,1);
		     	
		RecordSet.executeProc("CptStockInDetail_Insert",para);
				

		}
	}
}  } else if (ismode.equals("1")) {
	for(int i=0;i<rowsum;i++) {
		String cpttype = Util.null2String(fu.getParameter("field159_"+i));//资产资料
		String plannumber = Util.null2String(fu.getParameter("field326_"+i));//数量
		String  price = Util.null2String(fu.getParameter("field327_"+i));//单价
		String  StockInDate_dtl = Util.null2String(fu.getParameter("field329_"+i));//购置日期
		String capitalspec = Util.null2String(fu.getParameter("field6045_"+i));
		String location = "";//存放地点,流程中没有此字段
		String Invoice = "";//发票号,流程中没有此字段
		String customerid_dtl = "";//供应商,流程中没有此字段
	    
	    String sptcount1="";//sptcount1为1表示单独核算
		RecordSet.executeProc("CptCapital_SelectByID",cpttype);
    if(RecordSet.next()){
    	sptcount1 = RecordSet.getString("sptcount");
    }
		if(sptcount1.equals("1")){
		  plannumber = (int)Util.getFloatValue(plannumber,0) + "";
		  for (int j=0;j<Util.getIntValue(plannumber,0);j++){//单独核算根据实际入库的数量每个资产单独为一条记录
				para = cptstockinid;
				para +=separator+cpttype;
				para +=separator+"1";//计划入库数量
				para +=separator+"1";//实际入库数量
				para +=separator+price;
			  para +=separator+customerid_dtl;
			  para +=separator+StockInDate_dtl;
			  para +=separator+capitalspec;
			  para +=separator+location;
			  para +=separator+Invoice;
				RecordSet.executeProc("CptStockInDetail_Insert",para);
			}
		}else{
			para = cptstockinid;
			para +=separator+cpttype;
			para +=separator+plannumber;//计划入库数量
			para +=separator+plannumber;//实际入库数量
			para +=separator+price;
		  para +=separator+customerid_dtl;
		  para +=separator+StockInDate_dtl;
		  para +=separator+capitalspec;
		  para +=separator+location;
		  para +=separator+Invoice;
			RecordSet.executeProc("CptStockInDetail_Insert",para);
		}
	}
}
  String departmentid = Util.fromScreen(fu.getParameter("field153"),user.getLanguage());  //入库部门
	String temprequestid 	= "0";     //该工作流的相关工作流	
	String resourceid = "0";		//申购人
	String stateid  = "1";	
	String capitalid = "";
	String tempmark = "";
	String isinner = "";
	String startdate = "";
	String enddate = "";
	String deprestartdate = "";
	String depreenddate = "";
	String manudate = "";
	//String location = "";
	String num = "";
	String tempid = "";
	String tempstr = "";
	para = "";
	String sptcount = "";
	String rltid = "";
	String relatefee = "";//流转相关金额
	String capitalgroupid = "";
	//String capitalspec = "";
	String selectdate ="";//购置日期
	String counttype = "";	
	ArrayList ids = new ArrayList();
	
	String customerid = "";
	String capitalspec = "";
	String location = "";
	String Invoice = "";	
	String stockindate = "";
	String capitaltypeid = "";//资产类型
	String blongsubcompany = "";//所属分部
	String blongdepartment = "";//所属部门
	
	RecordSet.executeProc("CptStockInDetail_SByStockid",cptstockinid);
	while(RecordSet.next()){
		tempid = RecordSet.getString("id");
		capitalid = RecordSet.getString("cpttype");
		num = RecordSet.getString("innumber");
    double innum = Util.getDoubleValue(num);
    double inprice = Util.getDoubleValue(RecordSet.getString("price"));
    customerid=RecordSet.getString("customerid");
    capitalspec=RecordSet.getString("capitalspec");
    location=RecordSet.getString("location");
    Invoice=RecordSet.getString("Invoice");
    stockindate=DateHelper.convertDateIntoYYYYMMDDStr(new Date());;
	selectdate=stockindate;
		relatefee = ""+(innum*inprice);
		
		RecordSetInner.executeProc("CptCapital_SelectByID",capitalid);
    if(RecordSetInner.next()){
    	tempmark = RecordSetInner.getString("mark");
    	sptcount = RecordSetInner.getString("sptcount");
    	//capitalspec = RecordSetInner.getString("capitalspec");
    	capitalgroupid = RecordSetInner.getString("capitalgroupid");
		capitaltypeid = RecordSetInner.getString("capitaltypeid");
    }
    
    //判断是否固资或低耗1:固资2:低耗
    String tempstr2 = "2,3,4,5,6,7,8,9";
    String rootgroupid = capitalgroupid;
    int loop =10;
    while(loop>0){
    	if((CapitalAssortmentComInfo.getSupAssortmentId(rootgroupid)).equals("0") || "".equals(CapitalAssortmentComInfo.getSupAssortmentId(rootgroupid))){
				break;
		}
		rootgroupid = CapitalAssortmentComInfo.getSupAssortmentId(rootgroupid);
		loop--;
	}
	
    if(inprice>=2000){   //单独核算的资产(固资或低耗)
        counttype = "1";
    }else{
        counttype = "2";
    }

	blongsubcompany = DepartmentComInfo.getSubcompanyid1(departmentid);
	blongdepartment = departmentid;
	
	//获得资产编号
	if(sptcount.equals("1")){
		tempmark = CodeBuild.getCurrentCapitalCode(DepartmentComInfo.getSubcompanyid1(departmentid),departmentid,capitalgroupid,capitaltypeid,selectdate,stockindate,capitalid);
	}

		RecordSetInner.executeProc("CptCapital_SelectByDataType",capitalid+separator+departmentid);
   	if(!sptcount.equals("1") && RecordSetInner.next()){
    	tempmark = RecordSetInner.getString("mark");
    }else if(!sptcount.equals("1")){
    	tempmark = CodeBuild.getCurrentCapitalCode(DepartmentComInfo.getSubcompanyid1(departmentid),departmentid,capitalgroupid,capitaltypeid,selectdate,stockindate,capitalid);
    }

    
    //如果是非单独核算并且部门有此资产那么编号不变
	
		para = stockindate;//入库日期
		para +=separator+departmentid;//流转至部门
		para +=separator+BuyerID; //流转至人
		para +=separator+CheckerID; //入库人
		para +=separator+num; //流转数量
		para +=separator+location;
		para +=separator+temprequestid;
		para +=separator+"";//相关公司(入库无)
		para +=separator+relatefee;//相关金额
		para +=separator+stateid;//流转后的状态(使用或库存)
		para +=separator+"";//流转原因(暂空)
		para +=separator+tempmark;//自动生成的资产编号
		para +=separator+capitalid;//datetype
		para +=separator+startdate;
		para +=separator+enddate;
		para +=separator+deprestartdate;
		para +=separator+depreenddate;
		para +=separator+manudate;
		para += separator+CheckerID;
		para += separator+StockInDate;
		para += separator+currenttime;
		
		String para1 = "";
		//复制卡片
    if(sptcount.equals("1")){
        //单独核算
        //复制一项
        para1 =capitalid;
        para1 +=separator+customerid;
        para1 +=separator+""+inprice;
        para1 +=separator+capitalspec;
        para1 +=separator+location;
        para1 +=separator+Invoice;
        para1 +=separator+stockindate;//入库日期
        para1 +=separator+selectdate;//购置日期

        RecordSetInner.executeProc("CptCapital_Duplicate",para1);
        RecordSetInner.next();
        rltid =RecordSetInner.getString(1);

        para = rltid+separator+para;
        para += separator+""+inprice;
        para += separator+customerid;
        para += separator+counttype;
        para += separator+isinner;
        //更新信息,加入入库信息
        RecordSetInner.executeProc("CptUseLogInStock_Insert",para);
        RecordSetInner.execute("update cptcapital set departmentid=null where id='"+rltid+"'");
		RecordSetInner.executeSql("update cptcapital set olddepartment = " + departmentid + ",blongsubcompany='"+ blongsubcompany +"', blongdepartment='"+ blongdepartment +"' where id = " + rltid);

        //给资产加上权限未经测试
        String ProcPara ="";
        String sharetype="";
        String seclevel="";
        String rolelevel="";
        String sharelevel= "";
        String userid= "";
        String sharedepartmentid="";
        String roleid= "";
        String foralluser= "";
        String subcompanyid= "";

        //判断资产的跟类rootgroupid的权限
        RecordSetInner.executeSql("select * from CptAssortmentShare where assortmentid="+rootgroupid);
        while (RecordSetInner.next()){
            sharetype= RecordSetInner.getString("sharetype");
            seclevel= RecordSetInner.getString("seclevel");
            rolelevel= RecordSetInner.getString("rolelevel");
            sharelevel= RecordSetInner.getString("sharelevel");
            userid= RecordSetInner.getString("userid");
            sharedepartmentid= RecordSetInner.getString("departmentid");
            roleid= RecordSetInner.getString("roleid");
            foralluser= RecordSetInner.getString("foralluser");
            subcompanyid= RecordSetInner.getString("subcompanyid");

            ProcPara = rltid;
            ProcPara += separator+sharetype;
            ProcPara += separator+seclevel;
            ProcPara += separator+rolelevel;
            ProcPara += separator+sharelevel;
            ProcPara += separator+userid;
            ProcPara += separator+sharedepartmentid;
            ProcPara += separator+roleid;
            ProcPara += separator+foralluser;
            ProcPara += separator+subcompanyid;
            ProcPara += separator+rootgroupid;

            RecordSet1.executeProc("CptShareInfo_Insert_dft",ProcPara);//把资产加入到CptCapitalShareInfo表里
        }
        CptShare.setCptShareByCpt(rltid);//更新detail表

        ids.add(rltid);
    }else{
        //非单独核算
        RecordSetInner.executeProc("CptCapital_SelectByDataType",capitalid+separator+departmentid);
        if(RecordSetInner.next()){
            //该部门已有该资产
            //费用平均
            rltid = RecordSetInner.getString("id");
            double oldprice = Util.getDoubleValue(RecordSetInner.getString("startprice"));
            double oldnum   = Util.getDoubleValue(RecordSetInner.getString("capitalnum"));
            if((oldnum+innum)>0){
            	inprice = (oldprice*oldnum+inprice*Util.getDoubleValue(num))/(oldnum+innum);
            }

            para = rltid+separator+para;
            para += separator+""+inprice;
            para += separator+customerid;
            para += separator+counttype;
            para += separator+isinner;

            //更新信息,加入入库信息
            RecordSetInner.executeProc("CptUseLogInStock_Insert",para);
            RecordSetInner.execute("update cptcapital set departmentid=null where id='"+rltid+"'");
            String oldCapitalspec= Util.null2String(CptDwrUtil.getCptInfoMap(rltid).get("capitalspec"));
            if(!"".equals( oldCapitalspec)){
            	capitalspec=oldCapitalspec;
            }
            
            
            para1 =rltid;
            para1 +=separator+""+inprice;
            para1 +=separator+capitalspec;
            para1 +=separator+customerid;
            para1 +=separator+location;
            para1 +=separator+Invoice;
            para1 +=separator+stockindate;
            RecordSetInner.executeProc("CptCapital_UpdatePrice",para1);  
        }else{
            //该部门没有该资产
            //复制一项
            para1 =capitalid;
            para1 +=separator+customerid;
            para1 +=separator+""+inprice;
            para1 +=separator+capitalspec;
            para1 +=separator+location;
            para1 +=separator+Invoice;
            para1 +=separator+stockindate;//入库日期
            para1 +=separator+selectdate;//购置日期

            RecordSetInner.executeProc("CptCapital_Duplicate",para1);
            RecordSetInner.next();
            rltid =RecordSetInner.getString(1);

            para = rltid+separator+para;
            para += separator+""+inprice;
            para += separator+customerid;
            para += separator+counttype;
            para += separator+isinner;

            //更新信息,加入入库信息
            RecordSetInner.executeProc("CptUseLogInStock_Insert",para);
            RecordSetInner.execute("update cptcapital set departmentid=null where id='"+rltid+"'");
			RecordSetInner.executeSql("update cptcapital set olddepartment = " + departmentid + ",blongsubcompany='"+ blongsubcompany +"', blongdepartment='"+ blongdepartment +"' where id = " + rltid);

            //给资产加上权限未经测试
            String ProcPara ="";
            String sharetype="";
            String seclevel="";
            String rolelevel="";
            String sharelevel= "";
            String userid= "";
            String sharedepartmentid="";
            String roleid= "";
            String foralluser= "";
            String subcompanyid= "";
            //判断资产的跟类rootgroupid的权限
            RecordSetInner.executeSql("select * from CptAssortmentShare where assortmentid="+rootgroupid);
            while (RecordSetInner.next()){
                sharetype= RecordSetInner.getString("sharetype");
                seclevel= RecordSetInner.getString("seclevel");
                rolelevel= RecordSetInner.getString("rolelevel");
                sharelevel= RecordSetInner.getString("sharelevel");
                userid= RecordSetInner.getString("userid");
                sharedepartmentid= RecordSetInner.getString("departmentid");
                roleid= RecordSetInner.getString("roleid");
                foralluser= RecordSetInner.getString("foralluser");
                subcompanyid= RecordSetInner.getString("subcompanyid");

                ProcPara = rltid;
                ProcPara += separator+sharetype;
                ProcPara += separator+seclevel;
                ProcPara += separator+rolelevel;
                ProcPara += separator+sharelevel;
                ProcPara += separator+userid;
                ProcPara += separator+sharedepartmentid;
                ProcPara += separator+roleid;
                ProcPara += separator+foralluser;
                ProcPara += separator+subcompanyid;
                ProcPara += separator+rootgroupid;

                RecordSet1.executeProc("CptShareInfo_Insert_dft",ProcPara);//把资产加入到CptCapitalShareInfo表里                
            }
            CptShare.setCptShareByCpt(rltid);//更新detail表

            ids.add(rltid);
        }
    } 
	}
	
	if(ids!=null&&ids.size()>0){//给资产申购人添加查看权限
		for(int ii=0;ii<ids.size();ii++){
			RecordSet1.executeSql("INSERT INTO CptCapitalShareInfo (relateditemid , sharetype , seclevel , rolelevel , sharelevel , userid , departmentid ,roleid ,foralluser , crmid ,sharefrom , subcompanyid , isdefault)"+
					"VALUES ( "+ids.get(ii)+",8 , null ,   null ,  1 , "+BuyerID+" , null , null , null , 0 ,null , null , 1 )");
		}
	}
	
  CapitalComInfo.addCapitalCache(ids);
  PoppupRemindInfoUtil.updatePoppupRemindInfo(user.getUID(),11,"0",Util.getIntValue(cptstockinid));
}
//审批通过后到归档节点，更新资产表。功能相当于：资产管理-〉资产管理-〉入库验收 ==结束==




boolean logstatus = RequestManager.saveRequestLog() ;
WFManager.setWfid(workflowid);
WFManager.getWfInfo();
String isShowChart = Util.null2String(WFManager.getIsShowChart());
if ("1".equals(isShowChart)) {
	out.print("<script>wfforward('/workflow/request/WorkflowDirection.jsp?requestid=" + requestid + "&workflowid=" + workflowid + "&isbill=" + isbill + "&formid=" + formid+"');</script>");
}  else{

	//out.print("<script>wfforward('/workflow/request/RequestView.jsp?f_weaver_belongto_userid="+user.getUID()+"&f_weaver_belongto_usertype="+f_weaver_belongto_usertype+"');</script>");
	%>
	<%@ include file="/workflow/request/RedirectPage.jsp" %> 
	<%
	
}
%>