
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSetV" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="SysRemindWorkflow" class="weaver.system.SysRemindWorkflow" scope="page" />
<jsp:useBean id="ContractComInfo" class="weaver.crm.Maint.ContractComInfo" scope="page"/>
<jsp:useBean id="ContractViewer" class="weaver.crm.ContractViewer" scope="page"/>
<jsp:useBean id="ContacterShareBase" class="weaver.crm.ContacterShareBase" scope="page"/>
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page" />
<jsp:useBean id="SysCreateWF" class="weaver.system.SysCreateWF" scope="page" />
<%
    String crmId = Util.fromScreen(request.getParameter("crmId"),user.getLanguage());
    String contractId = Util.fromScreen(request.getParameter("contractId"),user.getLanguage());
    String method = Util.fromScreen(request.getParameter("method"),user.getLanguage());
    String isfromtab  = Util.null2String(request.getParameter("isfromtab"),"false");
    
    if (!contractId.equals(""))
    crmId = ContractComInfo.getContractcrmid(contractId);
    String useridcheck=""+user.getUID();

    boolean canview=false;
    boolean canedit=false;
    boolean canprove=false;

        //modified by lupeng 2004.2.13
        if (method != null && !method.equals("add")) {
        	
            int sharelevel = ContacterShareBase.getRightLevelForContacter(user.getUID()+"" , contractId);
            if(sharelevel > 0 ){
            	 canview=true;
            	 if(sharelevel == 2){
            		canedit=true;	  
            	 }else if (sharelevel == 3 || sharelevel == 4){
            		canedit=true;
            		canprove=true;
            	 }
            }
        }
        //end

    Calendar today = Calendar.getInstance();
    String currentdate = Util.add0(today.get(Calendar.YEAR), 4) +"-"+
                         Util.add0(today.get(Calendar.MONTH) + 1, 2) +"-"+
                         Util.add0(today.get(Calendar.DAY_OF_MONTH), 2) ;
    Calendar now = Calendar.getInstance();
    String currenttime = Util.add0(now.getTime().getHours(), 2) +":"+
                         Util.add0(now.getTime().getMinutes(), 2) +":"+
                         Util.add0(now.getTime().getSeconds(), 2) ;



    String name = Util.fromScreen(request.getParameter("name"),user.getLanguage());
    String typeId = Util.fromScreen(request.getParameter("typeId"),user.getLanguage());
    String docId = Util.fromScreen(request.getParameter("docId"),user.getLanguage());
    String price = request.getParameter("price");

    String contacterID = Util.fromScreen(request.getParameter("contacterID"),user.getLanguage());
		String sellChanceId = Util.fromScreen(request.getParameter("sellChanceId"),user.getLanguage());
		
    String status = Util.fromScreen(request.getParameter("status"),user.getLanguage());
    String manager = Util.fromScreen(request.getParameter("manager"),user.getLanguage());
    String startdate = Util.fromScreen(request.getParameter("startdate"),user.getLanguage());
    String enddate = Util.fromScreen(request.getParameter("enddate"),user.getLanguage());
    String isremind = "" + Util.getIntValue(request.getParameter("isremind"),1);//为1不提醒
    String before = Util.fromScreen(request.getParameter("before"),user.getLanguage());

    String ProjID = Util.fromScreen(request.getParameter("ProjID"),user.getLanguage());

    String departmentid = ResourceComInfo.getDepartmentID(manager);
    String subcompanyid1 = DepartmentComInfo.getSubcompanyid1(departmentid);
    String savePart = Util.fromScreen(request.getParameter("savePart"),user.getLanguage());

    int rownum = Util.getIntValue(request.getParameter("rownum"),0);
    int rownum1 = Util.getIntValue(request.getParameter("rownum1"),0);

    if (!method.equals("add"))
        if (!canedit) response.sendRedirect("/notice/noright.jsp") ;
/*check right end*/

    String para = "";
    char separator = Util.getSeparator() ;
    if (method.equals("add")){
        para = name;
        para +=separator+typeId;
        para +=separator+docId;
        para +=separator+price;
        para +=separator+crmId;
        para +=separator+contacterID;
        para +=separator+startdate;
        para +=separator+enddate;
        para +=separator+manager;
        para +=separator+"0" ;//0为提交
        para +=separator+isremind;
        para +=separator+before;
        para +=separator+""+user.getUID();
        para +=separator+currentdate;
        para +=separator+currenttime;
        para +=separator+ProjID;

        RecordSet.executeProc("CRM_Contract_Insert",para);
        RecordSet.next();
        contractId=RecordSet.getString("id");
        if(departmentid.equals("")){
          departmentid = "\'\'";
         }
        if(subcompanyid1.equals("")){
          subcompanyid1 = "\'\'";
         }
        if(sellChanceId.equals("")){
          sellChanceId = "\'\'";
         }
        RecordSet.executeSql("update CRM_Contract set department = " + departmentid + " , subcompanyid1 = " + subcompanyid1 + " , sellChanceId = " + sellChanceId + " where id = " + contractId);

        String productname = "";
        String assetunitid = "";
        String currencyid = "";
        String productPrice = "";
        String productDepreciation = "";
        String productNumber = "";
        String productPrices = "";
        String productDate = "";
        String productIsRemind = "";


        for (int i=0;i<rownum;i++)
        {
            productname = "" + Util.getIntValue(request.getParameter("productname_"+i),0);
            assetunitid = "" + Util.getIntValue(request.getParameter("assetunitid_"+i),0);
            currencyid = "" + Util.getIntValue(request.getParameter("currencyid_"+i),0);
            productPrice = request.getParameter("productPrice_"+i);
            productDepreciation = Util.fromScreen(request.getParameter("productDepreciation_"+i),user.getLanguage());
            productNumber = request.getParameter("productNumber_"+i);
            productPrices = request.getParameter("productPrices_"+i);
            productDate = Util.fromScreen(request.getParameter("productDate_"+i),user.getLanguage());
            productIsRemind = "" + Util.getIntValue(request.getParameter("productIsRemind_"+i),1);//为1不提醒

            if (!productname.equals("0")) {
                para = contractId;
                para +=separator+productname;
                para +=separator+assetunitid;
                para +=separator+productNumber;
                para +=separator+productPrice;
                para +=separator+currencyid;
                para +=separator+productDepreciation;
                para +=separator+productPrices;
                para +=separator+productDate;
                para +=separator+"0"; //实际交货量为默认为0
                para +=separator+"";
                para +=separator+"1"; //1为未处理完毕
                para +=separator+productIsRemind;

                RecordSet.executeProc("CRM_ContractProduct_Insert",para);
            }
        }

        String paymethodName = "";
        String paymethodType = "";
        String paymethodPrice = "";
        String paymethodDate = "";
        String paymethodDesc = "";
        String paymethodIsRemind = "";
        String BudgetType ="";


        for (int i=0;i<rownum1;i++)
        {
            paymethodName = Util.fromScreen(request.getParameter("paymethodName_"+i),user.getLanguage());
            paymethodType = Util.fromScreen(request.getParameter("paymethodType_"+i),user.getLanguage());
            paymethodPrice = request.getParameter("paymethodPrice_"+i);
            paymethodDate = Util.fromScreen(request.getParameter("paymethodDate_"+i),user.getLanguage());
            paymethodDesc = Util.fromScreen(request.getParameter("paymethodDesc_"+i),user.getLanguage());
            paymethodIsRemind = "" + Util.getIntValue(request.getParameter("paymethodIsRemind_"+i),1);//为1不提醒
            BudgetType = Util.fromScreen(request.getParameter("BudgetType_"+i),user.getLanguage());

            if (!paymethodName.equals("")) {
                para = contractId;
                para +=separator+paymethodName;
                para +=separator+paymethodType;
                para +=separator+paymethodPrice;
                para +=separator+paymethodDate;
                para +=separator+"0";//实际付款
                para +=separator+"";//实际付款时间
                para +=separator+paymethodDesc;
                para +=separator+"1"; //1为未处理完毕
                para +=separator+paymethodIsRemind;
                para +=separator+BudgetType ;

                RecordSet.executeProc("CRM_ContractPayMethod_Insert",para);
            }
        }


        String SWFAccepter=ResourceComInfo.getManagerID(""+user.getUID());
        String SWFTitle=SystemEnv.getHtmlLabelName(15139,user.getLanguage());
        SWFTitle += name;
        SWFTitle += "-"+ResourceComInfo.getResourcename(""+user.getUID());
        SWFTitle += "-"+currentdate;
        String SWFRemark=Util.fromScreen2(SystemEnv.getHtmlLabelName(15140,user.getLanguage()),user.getLanguage())+": <a href=/CRM/data/ContractView.jsp?CustomerID="+crmId+"&id="+contractId+">"+Util.fromScreen2(name,user.getLanguage())+"</a>";
        String SWFSubmiter=""+user.getUID();	SysRemindWorkflow.setCRMSysRemind(SWFTitle,Util.getIntValue(crmId),Util.getIntValue(SWFSubmiter),SWFAccepter,SWFRemark);

        ContractComInfo.removeContractCache();
        ContacterShareBase.setDefaultShare(contractId);
        //ContractViewer.setContractShareById(contractId);
        
        // response.sendRedirect("ContractView.jsp?CustomerID="+crmId+"&id="+contractId);
        out.println("<script>parent.getParentWindow(window).closeDialog()</script>");
    } //add完
    else
    if (method.equals("edit")){
        String managerOld = "" ;
        String crmIdOld = "" ;
        RecordSet.executeSql("select manager , crmId from CRM_Contract where id = " + contractId);
        RecordSet.next();
        managerOld = RecordSet.getString("manager");
        crmIdOld = RecordSet.getString("crmId");
        crmId = Util.fromScreen(request.getParameter("crmId"),user.getLanguage());
        para = contractId;
        para +=separator+name;
        para +=separator+typeId;
        para +=separator+docId;
        para +=separator+price;
        para +=separator+crmId;
        para +=separator+contacterID;
        para +=separator+startdate;
        para +=separator+enddate;
        para +=separator+manager;
        para +=separator+status ;//0为提交
        para +=separator+isremind;
        para +=separator+before;
        para +=separator+ProjID;

        //out.print(para);
        RecordSet.executeProc("CRM_Contract_Update",para);
        
       if(departmentid.equals("")){
          departmentid = "\'\'";
         }
        if(subcompanyid1.equals("")){
          subcompanyid1 = "\'\'";
         }
        if(sellChanceId.equals("")){
          sellChanceId = "\'\'";
         }
        RecordSet.executeSql("update CRM_Contract set department = " + departmentid + " , subcompanyid1 = " + subcompanyid1 + " , sellChanceId = " + sellChanceId + " where id = " + contractId);

        String canDeleteP = "";
        String productId = "";
        String productname = "";
        String assetunitid = "";
        String currencyid = "";
        String productPrice = "";
        String productDepreciation = "";
        String productNumber = "";
        String productPrices = "";
        String productDate = "";
        String productIsRemind = "";

        String notInId = "";
        for (int i=0;i<rownum;i++)
        {	canDeleteP = Util.fromScreen(request.getParameter("canDeleteP_"+i),user.getLanguage());
            productId = Util.fromScreen(request.getParameter("productId_"+i),user.getLanguage());
            if (canDeleteP.equals("1"))
                {if (notInId.equals("")) notInId = productId;
                   else notInId +="," + productId;}
        }

        //modify by dongping for TD843 and TD844 begin
        String strSqlDelAll = "" ;
        if ("".equals(notInId)) {
            strSqlDelAll = "DELETE CRM_ContractProduct WHERE id is not null  and  contractId ="+ contractId;            
        } else {
            strSqlDelAll = " DELETE CRM_ContractProduct WHERE id not in("+notInId+") and  contractId ="+ contractId ;        
        }
		RecordSet.executeSql(strSqlDelAll);
       //end .

        for (int i=0;i<rownum;i++)
        {
            canDeleteP = Util.fromScreen(request.getParameter("canDeleteP_"+i),user.getLanguage());
            productId = Util.fromScreen(request.getParameter("productId_"+i),user.getLanguage());
            productname = "" + Util.getIntValue(request.getParameter("productname_"+i),0);
            assetunitid = "" + Util.getIntValue(request.getParameter("assetunitid_"+i),0);
            currencyid = "" + Util.getIntValue(request.getParameter("currencyid_"+i),0);
            productPrice = request.getParameter("productPrice_"+i);
            productDepreciation = Util.fromScreen(request.getParameter("productDepreciation_"+i),user.getLanguage());
            productNumber = request.getParameter("productNumber_"+i);
            productPrices = request.getParameter("productPrices_"+i);
            productDate = Util.fromScreen(request.getParameter("productDate_"+i),user.getLanguage());
            productIsRemind = "" + Util.getIntValue(request.getParameter("productIsRemind_"+i),1);//为1不提醒

            if (canDeleteP.equals("0")){
                if (!productname.equals("0")) {
                    para = contractId;
                    para +=separator+productname;
                    para +=separator+assetunitid;
                    para +=separator+productNumber;
                    para +=separator+productPrice;
                    para +=separator+currencyid;
                    para +=separator+productDepreciation;
                    para +=separator+productPrices;
                    para +=separator+productDate;
                    para +=separator+"0"; //实际交货量为默认为0
                    para +=separator+"";
                    para +=separator+"1"; //1为未处理完毕
                    para +=separator+productIsRemind;

                    RecordSet.executeProc("CRM_ContractProduct_Insert",para);
                }
            }
            else{
                if (!productname.equals("0")) {
                    para = productId;
                    para +=separator+productname;
                    para +=separator+assetunitid;
                    para +=separator+currencyid;
                    para +=separator+productPrice;
                    para +=separator+productDepreciation;
                    para +=separator+productNumber;
                    para +=separator+productPrices;
                    para +=separator+productDate;
                    para +=separator+productIsRemind;
                    RecordSet.executeProc("CRM_ContractProduct_Update1",para);
                }
            }
        }

        String canDeleteM = "";
        String payMethodId = "";
        String paymethodName = "";
        String paymethodType = "";
        String paymethodPrice = "";
        String paymethodDate = "";
        String paymethodDesc = "";
        String paymethodIsRemind = "";
        String BudgetType = "";

        notInId = "";
        for (int i=0;i<rownum1;i++)
        {	canDeleteM = Util.fromScreen(request.getParameter("canDeleteM_"+i),user.getLanguage());
            payMethodId = Util.fromScreen(request.getParameter("payMethodId_"+i),user.getLanguage());
            if (canDeleteM.equals("1"))
                {if (notInId.equals("")) notInId = payMethodId;
                   else notInId +="," + payMethodId;}
        }

       //modify by dongping for TD843 and TD844 begin
       if ("".equals(notInId)) {
            strSqlDelAll = "DELETE CRM_ContractPayMethod WHERE id is not null  and  contractId ="+ contractId;            
        } else {
            strSqlDelAll = " DELETE CRM_ContractPayMethod WHERE id not in("+notInId+") and  contractId ="+ contractId ;        
        }  
		RecordSet.executeSql(strSqlDelAll);
       //end .

        for (int i=0;i<rownum1;i++)
        {
        		
            canDeleteM = Util.fromScreen(request.getParameter("canDeleteM_"+i),user.getLanguage());
            payMethodId = Util.fromScreen(request.getParameter("payMethodId_"+i),user.getLanguage());
            paymethodName = Util.fromScreen(request.getParameter("paymethodName_"+i),user.getLanguage());
            paymethodType = Util.fromScreen(request.getParameter("paymethodType_"+i),user.getLanguage());
            paymethodPrice = request.getParameter("paymethodPrice_"+i);
            
            paymethodDate = Util.fromScreen(request.getParameter("paymethodDate_"+i),user.getLanguage());
            paymethodDesc = Util.fromScreen(request.getParameter("paymethodDesc_"+i),user.getLanguage());
            paymethodIsRemind = "" + Util.getIntValue(request.getParameter("paymethodIsRemind_"+i),1);//为1不提醒
            BudgetType = Util.fromScreen(request.getParameter("BudgetType_"+i),user.getLanguage());

            if (canDeleteM.equals("0")){
            
                if (!paymethodName.equals("")) {
                    para = contractId;
                    para +=separator+paymethodName;
                    para +=separator+paymethodType;
                    para +=separator+paymethodPrice;
                    para +=separator+paymethodDate;
                    para +=separator+"0";//实际付款
                    para +=separator+"";//实际付款时间
                    para +=separator+paymethodDesc;
                    para +=separator+"1"; //1为未处理完毕
                    para +=separator+paymethodIsRemind;
                    para +=separator+BudgetType;
                    
                    RecordSet.executeProc("CRM_ContractPayMethod_Insert",para);
                }
            }
            else{
                if (!paymethodName.equals("")) {
                    para = payMethodId;
                    para +=separator+paymethodName;
                    para +=separator+paymethodType;
                    para +=separator+BudgetType;
                    para +=separator+paymethodPrice;
                    para +=separator+paymethodDate;
                    para +=separator+paymethodDesc;
                    para +=separator+paymethodIsRemind;
                    RecordSet.executeProc("CRM_ContractPayMethod_Update1",para);
                }
            }
        }

        String SWFAccepter=ResourceComInfo.getManagerID(""+user.getUID());
        String SWFTitle=SystemEnv.getHtmlLabelName(15164,user.getLanguage());
        SWFTitle += name;
        SWFTitle += "-"+ResourceComInfo.getResourcename(""+user.getUID());
        SWFTitle += "-"+currentdate;
        String SWFRemark=Util.fromScreen2(SystemEnv.getHtmlLabelName(15140,user.getLanguage()),user.getLanguage())+": <a href=/CRM/data/ContractView.jsp?CustomerID="+crmId+"&id="+contractId+">"+Util.fromScreen2(name,user.getLanguage())+"</a>";
        String SWFSubmiter=""+user.getUID();	SysRemindWorkflow.setCRMSysRemind(SWFTitle,Util.getIntValue(crmId),Util.getIntValue(SWFSubmiter),SWFAccepter,SWFRemark);

        ContractComInfo.removeContractCache();
        if ((!managerOld.equals(manager)) || (!crmIdOld.equals(crmId))) //如果负责人改变或客户改变改权限
            //ContractViewer.setContractShareById(contractId);
        	ContacterShareBase.setDefaultShare(contractId);
		if(isfromtab.equals("true")){
			response.sendRedirect("ContractView.jsp?needRefresh=true&isfromtab="+isfromtab+"&CustomerID="+crmId+"&id="+contractId);
			return;
		}else{
			out.println("<script>parent.getParentWindow(window).closeDialog()</script>");
		}
    }
    else
    if (method.equals("view")){

         /*String sql_U="update CRM_Contract set projid= "+ProjID+"where id ="+contractId;
        RecordSet.executeSql(sql_U);*/

        if (savePart.equals("1")) { //保存合同信息
            para = contractId ;
            para +=separator+isremind;
            para +=separator+before;
            RecordSet.executeProc("CRM_Contract_UpdateRemind",para);
        }
        if (savePart.equals("2")) { //保存产品信息
            String productId = "";
            String productFactNumber = "";
            String productFactDate = "";
            String productIsFinish = "";
            String productIsRemind = "";
            String productFormNum = "";

            for (int i=0;i<rownum;i++)
            {
                productId = "" + Util.getIntValue(request.getParameter("productId_"+i),0);
                productFactNumber = "" + Util.getFloatValue(request.getParameter("productFactNumber_"+i),0);
                productFactDate = Util.fromScreen(request.getParameter("productFactDate_"+i),user.getLanguage());
                productIsFinish = "" + Util.getIntValue(request.getParameter("productisFinish_"+i),1);//1为未处理完毕
                productIsRemind = "" + Util.getIntValue(request.getParameter("productisRemind_"+i),1);//为1不提醒
                productFormNum = Util.fromScreen(request.getParameter("productFormNum_"+i),user.getLanguage());//单据号

                if (!productFactNumber.equals("0")) {
//                    para = productId;
//                    para +=separator+productFactNumber;
//                    para +=separator+productFactDate;
//                    para +=separator+productFormNum;
//                    para +=separator+useridcheck;
//                    RecordSet.executeProc("CRM_ContractProInfo_Insert",para);
                    RecordSet.executeSql("insert into CRM_ContractProInfo(proid,factnum,factdate,formnum,creater) values(" + productId + "," + productFactNumber + ",'" + productFactDate + "','" + productFormNum + "'," + user.getUID() + ")");
                }
                RecordSet.executeProc("CRM_ContractProInfo_CountNum",productId);
                if (RecordSet.next()){
                    productFactNumber=""+Util.getFloatValue(RecordSet.getString(1),0);
                }else{
                    productFactNumber="0" ;
                }
                if (!productId.equals("0")) {
                    para = productId;
                    para +=separator+productFactNumber;
                    para +=separator+"";
                    para +=separator+productIsFinish;
                    para +=separator+productIsRemind;
                    RecordSet.executeSql("UPDATE  CRM_ContractProduct SET factnumber_n = "+productFactNumber+" ,factDate = '' ,isFinish = "+productIsFinish+",isRemind = "+productIsRemind+" WHERE id = "+productId);
//                    RecordSet.executeProc("CRM_ContractProduct_Update",para);
                }
            }
        }
        if (savePart.equals("3")) { //保存付款方式信息
            String paymethodId = "";
            String paymethodFactPrice = "";
            String paymethodFactDate = "";
            String paymethodIsFinish = "";
            String paymethodIsRemind = "";
            String paymethodFormNum = "";

            for (int i=0;i<rownum1;i++)
            {
                paymethodId = "" + Util.getIntValue(request.getParameter("paymethodId_"+i),0);
                paymethodFactPrice = "" + Util.null2String(request.getParameter("paymethodFactPrice_"+i));//add by sjh 如果数据大会转变成科学计数影响存储过程
                paymethodFactDate = Util.fromScreen(request.getParameter("paymethodFactDate_"+i),user.getLanguage());
                paymethodIsFinish = "" + Util.getIntValue(request.getParameter("paymethodisFinish_"+i),1);//1为未处理完毕
                paymethodIsRemind = "" + Util.getIntValue(request.getParameter("paymethodisRemind_"+i),1);//为1不提醒
                paymethodFormNum = Util.fromScreen(request.getParameter("paymethodFormNum_"+i),user.getLanguage());

                if (!paymethodId.equals("0")) {
                    //插入付款信息到日志表中
                    /**/
                    double trueprice = Util.getDoubleValue(paymethodFactPrice);

                        if(trueprice > 0){
                            para = paymethodId;
                            para +=separator+paymethodFactPrice;
                            para +=separator+paymethodFactDate;
                            para +=separator+useridcheck; //creater
                            para +=separator+paymethodFormNum;
                           RecordSet.executeProc("CRM_PayInfo_Insert",para);
                        }

                    String sql_0="select sum(factprice) from CRM_PayInfo where payid="+paymethodId;
                    RecordSet.executeSql(sql_0);
                    RecordSet.next();
                    paymethodFactPrice = RecordSet.getString(1); //取每次付款的总和作为主表的factPrice
					if(paymethodFactPrice.equals("")){
					paymethodFactPrice = "" + 0;
					}
                    sql_0="select max(factdate) from CRM_PayInfo where payid="+paymethodId;
                    RecordSet.executeSql(sql_0);
                    RecordSet.next();
                    paymethodFactDate = RecordSet.getString(1);//取每次付款的最大日期最为主表的factdate

                    para = paymethodId;
                    para +=separator+paymethodFactPrice;
                    para +=separator+paymethodFactDate;
                    para +=separator+paymethodIsFinish;
                    para +=separator+paymethodIsRemind;

                    RecordSet.executeProc("CRM_ContractPayMethod_Update",para);

                    sql_0="select * from CRM_ContractPayMethod where id="+paymethodId;
                    RecordSet.executeSql(sql_0);
                    RecordSet.next();
                    String feetypeid = RecordSet.getString("feetypeid");

                    if(ProjID.equals("")) ProjID="0";
                    String amount = RecordSet.getString("factPrice");
                    String description = "";
                    String releatedname =SystemEnv.getHtmlLabelName(15142,user.getLanguage())+name;
                    String iscontractid = "1";
					if(amount.equals("")) amount = "0";

                    sql_0="select fnalogid from CRM_ContractPayMethod where id="+paymethodId;
                    RecordSet.executeSql(sql_0);
                    RecordSet.next();
                    String fnalogid_old = RecordSet.getString(1);

                    if(fnalogid_old.equals("")){   //插入到财务表
                        para = feetypeid;
                        para +=separator+manager;
                        para +=separator+departmentid;
                        para +=separator+crmId;
                        para +=separator+ProjID;
                        para +=separator+amount;
                        para +=separator+description;
                        para +=separator+currentdate;
                        para +=separator+contractId ;  //合同的id
                        para +=separator+releatedname;
                        para +=separator+iscontractid ;
                        RecordSet.executeProc("FnaAccountLog_Insert",para);

                        RecordSet.next();
                        String fnalogid  = RecordSet.getString(1);//返回财务表的id
                        sql_0="update CRM_ContractPayMethod set fnalogid="+fnalogid+" where id="+paymethodId;
                        RecordSet.executeSql(sql_0);
                    }else{//更新财务表
                        para = fnalogid_old;
                        para +=separator+amount;
                        para +=separator+ProjID;
                        RecordSet.executeProc("FnaAccountLog_Update",para);

                    }

                }
            }
        }

        response.sendRedirect("ContractView.jsp?isfromtab="+isfromtab+"&CustomerID="+crmId+"&id="+contractId);
    }
    else
    if (method.equals("isCustomerCheck")){
        String sqlStr = "Update CRM_Contract set status = 2 where id = " + contractId;
        RecordSet.executeSql(sqlStr);
        response.sendRedirect("ContractView.jsp?isfromtab="+isfromtab+"&needRefresh=true&CustomerID="+crmId+"&id="+contractId);
    }
    else
    if (method.equals("isSuccess")){
        String sqlStr = "Update CRM_Contract set status = 3 where id = " + contractId;
        RecordSet.executeSql(sqlStr);
        response.sendRedirect("ContractView.jsp?isfromtab="+isfromtab+"&needRefresh=true&CustomerID="+crmId+"&id="+contractId);
    }
    else
    if (method.equals("reopen")){

        String sqlStr = "Update CRM_Contract set status = status - 1  where id = " + contractId;
        RecordSet.executeSql(sqlStr);  //重新打开状态递减

        //String sqlStr0 = "delete FnaAccountLog   where iscontractid ='1' and  releatedid = " + contractId;
        //RecordSet.executeSql(sqlStr0);//财务中的实际收款要清0。

        response.sendRedirect("ContractView.jsp?isfromtab="+isfromtab+"&needRefresh=true&CustomerID="+crmId+"&id="+contractId);
    }

    else
    if(method.equals("payedit")){
        String PayInfoId = Util.fromScreen(request.getParameter("PayInfoId"),user.getLanguage());//主id
        String pay_id = Util.fromScreen(request.getParameter("pay_id"),user.getLanguage());
        String paytrueprice = Util.fromScreen(request.getParameter("paytrueprice"),user.getLanguage());
        String paytrueday = Util.fromScreen(request.getParameter("paytrueday"),user.getLanguage());
           String payFormNum = Util.fromScreen(request.getParameter("payFormNum"),user.getLanguage());

        para = PayInfoId;
        para +=separator+paytrueprice;
        para +=separator+paytrueday;
        para +=separator+useridcheck; //creater
        para +=separator+payFormNum; //payFormNum

        RecordSet.executeProc("CRM_PayInfo_update",para);

        String sql_1="select sum(factprice) from CRM_PayInfo where payid="+pay_id;
        RecordSet.executeSql(sql_1);
        RecordSet.next();
        String trueprice = RecordSet.getString(1);

        sql_1="update CRM_ContractPayMethod set factPrice ="+trueprice+"where  id = "+pay_id;
        RecordSet.executeSql(sql_1); //更新金额

        sql_1="select max(factdate) from CRM_PayInfo where payid="+pay_id;
        RecordSet.executeSql(sql_1);
        RecordSet.next();
        String truedate = RecordSet.getString(1);

        sql_1="update CRM_ContractPayMethod set factDate ='"+truedate+"' where  id = "+pay_id;
        RecordSet.executeSql(sql_1);//更新日期
        out.print(sql_1);

        //写到财务表
        sql_1="select fnalogid from CRM_ContractPayMethod where id="+pay_id;
        RecordSet.executeSql(sql_1);
        RecordSet.next();
        String fnalogid_old = RecordSet.getString(1);
        para = fnalogid_old;
        para +=separator+trueprice;
        para +=separator+ProjID;
        RecordSet.executeProc("FnaAccountLog_Update",para);


        response.sendRedirect("ContractView.jsp?isfromtab="+isfromtab+"&CustomerID="+crmId+"&id="+contractId);

    }
    else
    if(method.equals("paydel")){
        String PayInfoId = Util.fromScreen(request.getParameter("PayInfoId"),user.getLanguage());
        String payid = Util.fromScreen(request.getParameter("payid"),user.getLanguage());
        RecordSet.executeProc("CRM_PayInfo_del",PayInfoId);

        String sql_1="select sum(factprice) from CRM_PayInfo where payid="+payid;
        RecordSet.executeSql(sql_1);
        RecordSet.next();
        String trueprice = RecordSet.getString(1);
        if(trueprice.equals("")) trueprice="0";

        sql_1="update CRM_ContractPayMethod set factPrice ="+trueprice+"where  id = "+payid;
        RecordSet.executeSql(sql_1); //更新删除后的金额

        sql_1="select max(factdate) from CRM_PayInfo where payid="+payid;
        RecordSet.executeSql(sql_1);
        RecordSet.next();
        String truedate = RecordSet.getString(1);

        sql_1="update CRM_ContractPayMethod set factDate = '"+truedate+"' where  id = "+payid;
        RecordSet.executeSql(sql_1);//更新删除后的日期

        //写到财务表
        sql_1="select fnalogid from CRM_ContractPayMethod where id="+payid;
        RecordSet.executeSql(sql_1);
        RecordSet.next();
        String fnalogid_old = RecordSet.getString(1);
        para = fnalogid_old;
        para +=separator+trueprice;
        para +=separator+ProjID;
        RecordSet.executeProc("FnaAccountLog_Update",para);

        response.sendRedirect("ContractView.jsp?isfromtab="+isfromtab+"&CustomerID="+crmId+"&id="+contractId);
    }
    else
    if(method.equals("proedit")){
        String productFactNumber ="0";
        String proInfoId = Util.fromScreen(request.getParameter("proInfoId"),user.getLanguage());
        String proId = Util.fromScreen(request.getParameter("proId"),user.getLanguage());
        String proFactNum = Util.fromScreen(request.getParameter("proFactNum"),user.getLanguage());
        String proFactDate = Util.fromScreen(request.getParameter("proFactDate"),user.getLanguage());
        String proFormNum = Util.fromScreen(request.getParameter("proFormNum"),user.getLanguage());
//        para = proInfoId;
//        para +=separator+proFactNum;
//        para +=separator+proFactDate;
//        para +=separator+proFormNum;
//        para +=separator+useridcheck; //creater
//
//        RecordSet.executeProc("CRM_ContractProInfo_Update",para);

        RecordSet.executeSql("UPDATE  CRM_ContractProInfo SET factNum = "+proFactNum+" ,factDate = '"+proFactDate+"',formNum = '"+proFormNum+"',creater = "+useridcheck+" WHERE id = " + proInfoId);
        RecordSet.executeProc("CRM_ContractProInfo_CountNum",proId);
//        RecordSet.executeSql("select SUM(factNum) from CRM_ContractProInfo where proId="+proId);
        if (RecordSet.next()){
            productFactNumber=""+Util.getFloatValue(RecordSet.getString(1),0);
        }
        RecordSet.executeSql("update CRM_ContractProduct set factnumber_n = " + productFactNumber + " where id = " + proId);
        response.sendRedirect("ContractView.jsp?isfromtab="+isfromtab+"&CustomerID="+crmId+"&id="+contractId);
    }
    else
    if(method.equals("prodel")){
        String productFactNumber ="0";
        String proInfoId = Util.fromScreen(request.getParameter("proInfoId"),user.getLanguage());
        String proId = Util.fromScreen(request.getParameter("proId"),user.getLanguage());
        RecordSet.executeProc("CRM_ContractProInfo_Del",proInfoId);
        RecordSet.executeProc("CRM_ContractProInfo_CountNum",proId);
        if (RecordSet.next())
            productFactNumber=""+Util.getFloatValue(RecordSet.getString(1),0);
        RecordSet.executeSql("update CRM_ContractProduct set factnumber_n = " + productFactNumber + " where id = " + proId);
        response.sendRedirect("ContractView.jsp?isfromtab="+isfromtab+"&CustomerID="+crmId+"&id="+contractId);

    }
    else
    if(method.equals("approve")){
        int msg = 0;
        int workflowid = 0 ;
        int requestId =0 ;

        RecordSet.executeProc("CRM_Contract_SelectById",contractId);
        RecordSet.next();
        String typeidTemp = ""+Util.getIntValue(RecordSet.getString("typeId"),0) ;
        String resource_nTemp = ""+Util.getIntValue(RecordSet.getString("manager"),0) ;
        String requestname = "客户合同审批-" + Util.null2String(RecordSet.getString("name")) + "-" + currentdate;

        RecordSet.executeSql("select workflowid from CRM_ContractType where id = " + typeidTemp);
        if (RecordSet.next())
        {
            workflowid = Util.getIntValue(RecordSet.getString("workflowid"),0);
            if (workflowid>0)
            {		
            		String sql1 = "update CRM_contract set status=-1 where id="+contractId;
            		RecordSet.executeSql(sql1);
            		
            		//业务合同单据支持自定义字段改造
            		ArrayList infos = new ArrayList() ;
            		int formid = 0;
            		RecordSet.executeSql("select * from workflow_base where id="+workflowid);
            	  RecordSet.next();
            	  formid = RecordSet.getInt("formid");
            	  String selectFields = "";
            	  RecordSet.executeSql("select fieldname from workflow_billfield where billid = "+formid+" order by dsporder");
            	  while(RecordSet.next()){//按显示顺序取得业务合同单据所有的字段
            	      if(selectFields.equals("")) selectFields = RecordSet.getString("fieldname");
            	      else selectFields += ","+RecordSet.getString("fieldname");
            	  }
            	  RecordSet.executeProc("CRM_Contract_SelectById",contractId);
            	  if(RecordSet.next()){//取合同的值，单据自定义字段值为空。
            	      ArrayList selectFieldsArr = Util.TokenizerString(selectFields,",");
            	      for(int tempIndex=0;tempIndex<selectFieldsArr.size();tempIndex++){
            	          String tempfieldname = (String)selectFieldsArr.get(tempIndex);
            	          String tempfieldvalue = "";
            	          if(tempfieldname.equals("resource_n"))
            	              tempfieldvalue = ""+Util.getIntValue(RecordSet.getString("manager"),0) ;
            	          else if(tempfieldname.equals("depid"))
            	              tempfieldvalue = ""+Util.getIntValue(RecordSet.getString("department"),0) ;  
            	          else if(tempfieldname.equals("approvids"))
            	              tempfieldvalue = "0" ;     
            	          else if(tempfieldname.equals("contractid"))
            	              tempfieldvalue = contractId ;  
            	          else if(tempfieldname.equals("typeid"))
            	              tempfieldvalue = ""+Util.getIntValue(RecordSet.getString("typeId"),0) ;  
            	          else if(tempfieldname.equals("docids"))
            	              tempfieldvalue = Util.null2String(RecordSet.getString("docId")) ; 
            	          else if(tempfieldname.equals("price"))
            	              tempfieldvalue = ""+Util.getDoubleValue(RecordSet.getString("price"),0) ;
            	          else if(tempfieldname.equals("startdate"))
            	              tempfieldvalue = Util.null2String(RecordSet.getString("startDate")) ;
            	          else if(tempfieldname.equals("enddate"))
            	              tempfieldvalue = Util.null2String(RecordSet.getString("endDate")) ;
            	          else if(tempfieldname.equals("crmid"))
            	              tempfieldvalue = Util.null2String(RecordSet.getString("crmId")) ;
            	          else if(tempfieldname.equals("prjid"))
            	              tempfieldvalue = Util.null2String(RecordSet.getString("projid")) ;
            	          else tempfieldvalue = "";
            	          infos.add(tempfieldvalue);//赋给流程中各字段的值
            	      }
            	  }
            	  //业务合同单据支持自定义字段改造
            	SysCreateWF.setUser(user);
                requestId=SysCreateWF.setWorkflowInfo(workflowid,requestname,Util.getIntValue(resource_nTemp,0),infos);
                msg=1;
            }
            else
                RecordSet.executeSql("update CRM_Contract set status = 1 where id = " + contractId);//如果没有审批工作流就直接改变
        }
        	response.sendRedirect("ContractView.jsp?isfromtab="+isfromtab+"&needRefresh=true&CustomerID="+crmId+"&id="+contractId+"&msg="+msg);
    }
    else
    if(method.equals("deleteContract")){
        String sqlStr = "delete from CRM_Contract  where id = " + contractId +" and crmid="+crmId ;
        RecordSet.executeSql(sqlStr);
    }else if(method.equals("batchDel")){
        String contractIds =Util.null2String(request.getParameter("contractIds"));
        if(!"".equals(contractIds)){
            contractIds = contractIds.substring(0,contractIds.length()-1);
            RecordSet.executeSql("delete from CRM_Contract where id in ("+contractIds+")");
        }
    }
%>
 <input type="button" name="Submit2" value="<%=SystemEnv.getHtmlLabelName(236,user.getLanguage())%>" onClick="javascript:history.go(-1)">

