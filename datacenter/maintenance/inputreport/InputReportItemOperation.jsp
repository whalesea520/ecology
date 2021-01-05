<%@ page language="java" contentType="text/html; charset=GBK" %> 
<%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSetTrans" class="weaver.conn.RecordSetTrans" scope="page" />
<jsp:useBean id="InputReportModuleFile" class="weaver.datacenter.InputReportModuleFile" scope="page" />
<jsp:useBean id="LabelComInfo" class="weaver.systeminfo.label.LabelComInfo" scope="page" />

<%
String operation = Util.null2String(request.getParameter("operation"));
String itemid = Util.null2String(request.getParameter("itemid"));
String inprepid = Util.null2String(request.getParameter("inprepid"));
String itemtypeid = Util.null2String(request.getParameter("itemtypeid"));
String itemdspname = Util.fromScreen(request.getParameter("itemdspname"),user.getLanguage());
String itemfieldname = Util.null2String(request.getParameter("itemfieldname"));
String itemfieldtype = Util.null2String(request.getParameter("itemfieldtype"));
String itemfieldscale = Util.null2String(request.getParameter("itemfieldscale"));
String itemexcelsheet = Util.null2String(request.getParameter("itemexcelsheet"));
String itemexcelrow = Util.null2String(request.getParameter("itemexcelrow"));
String itemexcelcolumn = Util.null2String(request.getParameter("itemexcelcolumn"));
String olditemfieldname = Util.null2String(request.getParameter("olditemfieldname"));
String olditemfieldtype = Util.null2String(request.getParameter("olditemfieldtype"));
String olditemfieldscale = Util.null2String(request.getParameter("olditemfieldscale"));
String gongsi = Util.null2String(request.getParameter("gongsi"));
String itemfieldunit = Util.fromScreen(request.getParameter("itemfieldunit"),user.getLanguage());
String dsporder = Util.null2String(request.getParameter("dsporder"));
String crmid = Util.null2String(request.getParameter("crmid"));
String closeid = Util.null2String(request.getParameter("closeid"));
String inputablefact = ""+Util.getIntValue(request.getParameter("inputablefact"),0);
String inputablebudg = ""+Util.getIntValue(request.getParameter("inputablebudg"),0);
String inputablefore = ""+Util.getIntValue(request.getParameter("inputablefore"),0);

String hasitem = Util.null2String(request.getParameter("hasitem")); //是否已经有同名的列


// if(itemfieldtype.equals("5")) itemexcelsheet = gongsi ;



int totaldetail = Util.getIntValue(request.getParameter("totaldetail"),0);

if((itemfieldscale.equals("") || itemfieldscale.equals("0")) && itemfieldtype.equals("1")) itemfieldscale = "60" ;
//if((itemfieldscale.equals("") || itemfieldscale.equals("0")) && itemfieldtype.equals("3")) itemfieldscale = "2" ;
if((itemfieldscale.equals("") || itemfieldscale.equals("0")) && (itemfieldtype.equals("3")||itemfieldtype.equals("5"))){
	itemfieldscale = "2" ;
}
if(olditemfieldscale.equals("0")) olditemfieldscale = "" ;




RecordSet.executeProc("T_InputReport_SelectByInprepid",""+inprepid);
RecordSet.next() ;
String inpreptablename = Util.null2String(RecordSet.getString("inpreptablename")) ;
String inprepbugtablename = Util.null2String(RecordSet.getString("inprepbugtablename")) ;
String inprepbudget = Util.null2String(RecordSet.getString("inprepbudget")) ;
String inprepforecast = Util.null2String(RecordSet.getString("inprepforecast")) ;
String isInputMultiLine = Util.null2String(RecordSet.getString("isInputMultiLine")) ;
int billId = Util.getIntValue(RecordSet.getString("billId"),0) ;

RecordSetTrans.setAutoCommit(false);

if(operation.equals("add")){
  try{	
    char separator = Util.getSeparator() ;

	String para = inprepid + separator + itemdspname
		+ separator + itemfieldname + separator + itemfieldtype + separator + itemfieldscale 
        + separator + itemtypeid + separator + itemexcelsheet + separator + itemexcelrow 
        + separator + itemexcelcolumn + separator + itemfieldunit  + separator + dsporder + separator + gongsi + separator + inputablefact + separator + inputablebudg + separator + inputablefore ;

	RecordSetTrans.executeProc("T_InputReportItem_Insert",para);

    int fieldLabel=0; 

	if(!hasitem.equals("1")) {

        String fieldName=itemfieldname;
        //int fieldLabel=0; 
		String fieldDbType=""; 
        String fieldHtmlType=""; 
        int type=0; 
        //int dspOrder=Util.getIntValue(dsporder,0);
        int dspOrder=Util.getIntValue(Util.getIntValues(dsporder),0);		
        int viewType=0;
        String detailTable="";
        String fromUser="1";
        if("oracle".equals(RecordSet.getDBType())){
			String altertable = " alter table " + inpreptablename + " add " + itemfieldname ;       
			switch (Util.getIntValue(itemfieldtype)) {
				case 1 :
					altertable += " varchar2("+itemfieldscale+") " ;
					fieldDbType="varchar2("+itemfieldscale+")";
					fieldHtmlType="1";
					type=1;
					break ;
				case 2 :
					altertable += " integer " ;
					fieldDbType="integer";
					fieldHtmlType="1";
					type=2;
					break ;
				case 3 :
					altertable += " number(15,"+itemfieldscale+") " ;
					fieldDbType="number(15,"+itemfieldscale+")";
					fieldHtmlType="1";
					type=3;
					break ;
				case 4 :
					altertable += " varchar2(100) " ;
					fieldDbType="varchar2(100)";
					fieldHtmlType="5";
					type=0;
					break ;
				case 5 :
					altertable += " number(15,"+itemfieldscale+") " ;
					fieldDbType="number(15,"+itemfieldscale+") ";
					fieldHtmlType="1";
					type=3;
					break ;
				case 6 :
					altertable += " varchar2(4000) " ;
					fieldDbType="varchar2(4000) ";
					fieldHtmlType="2";
					type=0;
					break ;
				case 7 :
					altertable += " integer " ;
					fieldDbType="integer";
					fieldHtmlType="1";
					type=Util.getIntValue(itemfieldscale,0);
					break ;
			}
			RecordSetTrans.executeSql(altertable);
		}else{
			String altertable = " alter table " + inpreptablename + " add " + itemfieldname ;
			switch (Util.getIntValue(itemfieldtype)) {
				case 1 :
					altertable += " varchar("+itemfieldscale+") " ;
					fieldDbType="varchar("+itemfieldscale+")";
					fieldHtmlType="1";
					type=1;
					break ;
				case 2 :
					altertable += " int " ;
					fieldDbType="int";
					fieldHtmlType="1";
					type=2;
					break ;
				case 3 :
					altertable += " decimal(15,"+itemfieldscale+") " ;
					fieldDbType="decimal(15,"+itemfieldscale+")";
					fieldHtmlType="1";
					type=3;
					break ;
				case 4 :
					altertable += " varchar(100) " ;
					fieldDbType="varchar(100)";
					fieldHtmlType="5";
					type=0;
					break ;
				case 5 :
					altertable += " decimal(15,"+itemfieldscale+") " ;
					fieldDbType="decimal(15,"+itemfieldscale+") ";
					fieldHtmlType="1";
					type=3;
					break ;
				case 6 :
					altertable += " text " ;
					fieldDbType="text";
					fieldHtmlType="2";
					type=0;
					break ;
				case 7 :
					altertable += " int " ;
					fieldDbType="int";
					fieldHtmlType="1";
					type=Util.getIntValue(itemfieldscale,0);
					break ;
			}
			RecordSetTrans.executeSql(altertable);
		}
        String sql="select id from HtmlLabelIndex where indexdesc='"+itemdspname+"'";
        RecordSetTrans.executeSql(sql);
        if(RecordSetTrans.next()){
			fieldLabel = Util.getIntValue(RecordSetTrans.getString("id"),0);
        }else{
			sql="select min(id) as id from HtmlLabelIndex";
			RecordSetTrans.executeSql(sql);
			if(RecordSetTrans.next()){
			    fieldLabel = Util.getIntValue(RecordSetTrans.getString("id"),0);
			}
			if(fieldLabel>0){
			    fieldLabel = -1;
			}
			fieldLabel-=1;		    	
			sql="INSERT INTO HtmlLabelIndex values("+fieldLabel+",'"+itemdspname+"')"; 
			RecordSetTrans.executeSql(sql);
			sql="INSERT INTO HtmlLabelInfo VALUES("+fieldLabel+",'"+itemdspname+"',7)";
			RecordSetTrans.executeSql(sql);		
			//LabelComInfo.addLabeInfoCache(String.valueOf(fieldLabel));
        }
		
		if(isInputMultiLine.equals("1")){
			viewType=1;
			detailTable=inpreptablename;
		}else{
			viewType=0;
			detailTable="";
		}



        RecordSetTrans.executeSql("INSERT INTO workflow_billfield ( billId, fieldName, fieldLabel, fieldDbType, fieldHtmlType, type, dspOrder, viewType,detailTable,fromUser) VALUES ("+billId+",'"+fieldName+"',"+fieldLabel+",'"+fieldDbType+"',"+fieldHtmlType+","+type+","+dspOrder+","+viewType+",'"+detailTable+"','"+fromUser+"')");
/*
        if(inprepbudget.equals("1")) {
            altertable = " alter table " + inprepbugtablename + " add " + itemfieldname ;
        
            switch (Util.getIntValue(itemfieldtype)) {
                case 1 :
                    altertable += " varchar("+itemfieldscale+") " ;
                    break ;
                case 2 :
                    altertable += " integer " ;
                    break ;
                case 3 :
                    altertable += " decimal(12,"+itemfieldscale+") " ;
                    break ;
                case 4 :
                    altertable += " varchar(100) " ;
                    break ;
                case 5 :
                    altertable += " decimal(12,"+itemfieldscale+") " ;
                    break ;
                case 6 :
                    altertable += " text " ;
                    break ;
            }
            
            RecordSetTrans.executeSql(altertable);
        }

        if(inprepforecast.equals("1")) {
            altertable = " alter table " + inpreptablename + "_forecast add " + itemfieldname ;
        
            switch (Util.getIntValue(itemfieldtype)) {
                case 1 :
                    altertable += " varchar("+itemfieldscale+") " ;
                    break ;
                case 2 :
                    altertable += " integer " ;
                    break ;
                case 3 :
                    altertable += " decimal(12,"+itemfieldscale+") " ;
                    break ;
                case 4 :
                    altertable += " varchar(100) " ;
                    break ;
                case 5 :
                    altertable += " decimal(12,"+itemfieldscale+") " ;
                    break ;
                case 6 :
                    altertable += " text " ;
                    break ;
            }
            
            RecordSetTrans.executeSql(altertable);
        }
*/
    }
	if(itemfieldtype.equals("4")){

            int newFieldId=0;
			int newItemId=0;
			RecordSetTrans.executeSql(" select id from workflow_billfield where billId="+billId+" and fieldName='"+itemfieldname+"' ");
			if(RecordSetTrans.next()){
				newFieldId=Util.getIntValue(RecordSetTrans.getString("id"),0);
			}
			RecordSetTrans.executeSql(" select itemId from T_InputReportItem where inprepId="+inprepid+" and itemFieldName='"+itemfieldname+"' ");
			if(RecordSetTrans.next()){
				newItemId=Util.getIntValue(RecordSetTrans.getString("itemId"),0);
			}
			if(newFieldId>0&&newItemId>0){
				for( int i =0 ; i< totaldetail ; i++) {
					String itemdsp = Util.fromScreen(request.getParameter("itemdsp"+i),user.getLanguage());
					int itemvalue = Util.getIntValue(request.getParameter("itemvalue"+i),-1);
					if(!itemdsp.equals("")){
						if(itemvalue<0){
							RecordSetTrans.executeSql("select max(itemValue) as maxItemValue from T_InputReportItemDetail where itemId="+newItemId);
							if(RecordSetTrans.next()){
								itemvalue=Util.getIntValue(RecordSetTrans.getString("maxItemValue"),-1);
							}
							itemvalue++;
						}
						para = ""+newItemId + separator + itemdsp + separator + itemvalue ;
						RecordSetTrans.executeProc("T_InputReportItemDetail_Insert",para);
						para=""+newFieldId+separator+"1"+separator+""+itemvalue+separator+itemdsp+separator+i+separator+"n";
						RecordSetTrans.executeProc("workflow_SelectItem_Insert",para);
					}
				}
			}
	}
	RecordSetTrans.commit();
    LabelComInfo.addLabeInfoCache(String.valueOf(fieldLabel));
  }catch(Exception exception){
	  RecordSetTrans.rollback();
  }
    //InputReportModuleFile.createModuleFile(""+inprepid, user) ;

 	response.sendRedirect("InputReportEdit.jsp?inprepid=" + inprepid);
 }
 
else if(operation.equals("edit")){
  try{
    String hisItemFieldName="";
	RecordSetTrans.executeSql("select itemFieldName from T_InputReportItem where itemId="+itemid);
	if(RecordSetTrans.next()){
		hisItemFieldName=Util.null2String(RecordSetTrans.getString("itemFieldName"));
	}

    char separator = Util.getSeparator() ;
    String para = itemid + separator + itemdspname
		+ separator + itemfieldname + separator + itemfieldtype + separator + itemfieldscale 
        + separator + itemtypeid + separator + itemexcelsheet + separator + itemexcelrow 
        + separator + itemexcelcolumn + separator + itemfieldunit   + separator + dsporder + separator + gongsi + separator + inputablefact + separator + inputablebudg + separator + inputablefore ;

	RecordSetTrans.executeProc("T_InputReportItem_Update",para);

    int fieldId=0;
	String fieldName=itemfieldname;
	int fieldLabel=0; 
	String fieldDbType=""; 
	String fieldHtmlType=""; 
	int type=0; 
	//int dspOrder=Util.getIntValue(dsporder,0);
    int dspOrder=Util.getIntValue(Util.getIntValues(dsporder),0);	


	RecordSetTrans.executeSql("select id,fieldDbType,fieldHtmlType,type from workflow_billfield where billId="+billId+" and fieldName='"+hisItemFieldName+"'");
	if(RecordSetTrans.next()){
		fieldId=Util.getIntValue(RecordSetTrans.getString("id"),0);
		fieldDbType=Util.null2String(RecordSetTrans.getString("fieldDbType"));
		fieldHtmlType=Util.null2String(RecordSetTrans.getString("fieldHtmlType"));
		type=Util.getIntValue(RecordSetTrans.getString("type"),0);
	}

    if(!olditemfieldtype.equals( itemfieldtype ) ||  !olditemfieldscale.equals( itemfieldscale )) {	
        if("oracle".equals(RecordSet.getDBType())){
          String altertable = " alter table " + inpreptablename + " modify " + olditemfieldname ;
          switch (Util.getIntValue(itemfieldtype)) {
            case 1 :
                altertable += " varchar2("+itemfieldscale+") " ;
			    fieldDbType="varchar2("+itemfieldscale+")";
			    fieldHtmlType="1";
				type=1;
                break ;
            case 2 :
                altertable += " integer " ;
			    fieldDbType="integer";
			    fieldHtmlType="1";
				type=2;
                break ;
            case 3 :
                altertable += " number(15,"+itemfieldscale+") " ;
			    fieldDbType="number(15,"+itemfieldscale+")";
			    fieldHtmlType="1";
				type=3;
                break ;
            case 4 :
                altertable += " varchar2(100) " ;
			    fieldDbType="varchar2(100)";
			    fieldHtmlType="5";
				type=0;
                break ;
            case 5 :
                altertable += " number(15,"+itemfieldscale+") " ;
			    fieldDbType="number(15,"+itemfieldscale+") ";
			    fieldHtmlType="1";
				type=3;
                break ;
            case 6 :
                altertable += " varchar2(4000) " ;
			    fieldDbType="varchar2(4000) ";
			    fieldHtmlType="2";
				type=0;
                break ;
            case 7 :
                altertable += " integer " ;
			    fieldDbType="integer";
			    fieldHtmlType="1";
				type=Util.getIntValue(itemfieldscale,0);
                break ;
        }
          RecordSetTrans.executeSql(altertable);
		}else{
			String altertable = " alter table " + inpreptablename + " alter column  " + olditemfieldname ;
			switch (Util.getIntValue(itemfieldtype)) {
				case 1 :
					altertable += " varchar("+itemfieldscale+") " ;
					fieldDbType="varchar("+itemfieldscale+")";
					fieldHtmlType="1";
					type=1;
					break ;
				case 2 :
					altertable += " int " ;
					fieldDbType="int";
					fieldHtmlType="1";
					type=2;
					break ;
				case 3 :
					altertable += " decimal(15,"+itemfieldscale+") " ;
					fieldDbType="decimal(15,"+itemfieldscale+")";
					fieldHtmlType="1";
					type=3;
					break ;
				case 4 :
					altertable += " varchar(100) " ;
					fieldDbType="varchar(100)";
					fieldHtmlType="5";
					type=0;
					break ;
				case 5 :
					altertable += " decimal(15,"+itemfieldscale+") " ;
					fieldDbType="decimal(15,"+itemfieldscale+") ";
					fieldHtmlType="1";
					type=3;
					break ;
				case 6 :
					altertable += " text " ;
					fieldDbType="text";
					fieldHtmlType="2";
					type=0;
					break ;
				case 7 :
					altertable += " int " ;
					fieldDbType="int";
					fieldHtmlType="1";
					type=Util.getIntValue(itemfieldscale,0);
					break ;
			}
         RecordSetTrans.executeSql(altertable);
		}

        
/*
        if(inprepbudget.equals("1")) {
            altertable = " alter table " + inprepbugtablename + " alter column  " + olditemfieldname ;
        
            switch (Util.getIntValue(itemfieldtype)) {
                case 1 :
                    altertable += " varchar("+itemfieldscale+") " ;
                    break ;
                case 2 :
                    altertable += " integer " ;
                    break ;
                case 3 :
                    altertable += " decimal(12,"+itemfieldscale+") " ;
                    break ;
                case 4 :
                    altertable += " varchar(100) " ;
                    break ;
                case 5 :
                    altertable += " decimal(12,"+itemfieldscale+") " ;
                    break ;
                case 6 :
                    altertable += " text " ;
                    break ;
            }
            
            RecordSetTrans.executeSql(altertable);
        }

        if(inprepforecast.equals("1")) {
            altertable = " alter table " + inpreptablename + "_forecast alter column  " + olditemfieldname ;
        
            switch (Util.getIntValue(itemfieldtype)) {
                case 1 :
                    altertable += " varchar("+itemfieldscale+") " ;
                    break ;
                case 2 :
                    altertable += " integer " ;
                    break ;
                case 3 :
                    altertable += " decimal(12,"+itemfieldscale+") " ;
                    break ;
                case 4 :
                    altertable += " varchar(100) " ;
                    break ;
                case 5 :
                    altertable += " decimal(12,"+itemfieldscale+") " ;
                    break ;
                case 6 :
                    altertable += " text " ;
                    break ;
            }
            
            RecordSetTrans.executeSql(altertable);
        }
*/
    }

        String sql="select id from HtmlLabelIndex where indexdesc='"+itemdspname+"'";
        RecordSetTrans.executeSql(sql);
        if(RecordSetTrans.next()){
			fieldLabel = Util.getIntValue(RecordSetTrans.getString("id"),0);
        }else{
			sql="select min(id) as id from HtmlLabelIndex";
			RecordSetTrans.executeSql(sql);
			if(RecordSetTrans.next()){
			    fieldLabel = Util.getIntValue(RecordSetTrans.getString("id"),0);
			}
			if(fieldLabel>0){
			    fieldLabel = -1;
			}
			fieldLabel-=1;		    	
			sql="INSERT INTO HtmlLabelIndex values("+fieldLabel+",'"+itemdspname+"')"; 
			RecordSetTrans.executeSql(sql);
			sql="INSERT INTO HtmlLabelInfo VALUES("+fieldLabel+",'"+itemdspname+"',7)";
			RecordSetTrans.executeSql(sql);		
			//LabelComInfo.addLabeInfoCache(String.valueOf(fieldLabel));
        }		
    RecordSetTrans.executeSql("update workflow_billfield set fieldName='"+fieldName+"',fieldLabel="+fieldLabel+",fieldDbType='"+fieldDbType+"',fieldHtmlType='"+fieldHtmlType+"',type="+type+",dspOrder="+dspOrder+" where id="+fieldId);

    if( !olditemfieldname.equals(itemfieldname) )  {
        
		if("oracle".equals(RecordSet.getDBType())){
			RecordSetTrans.executeSql("alter table "+inpreptablename+" rename column "+olditemfieldname+" to "+itemfieldname); 
		}else{
			RecordSetTrans.executeSql("exec sp_rename '"+inpreptablename+"."+olditemfieldname+"', '"+itemfieldname+"', 'column' ");  
		}

 /*       
        if(inprepbudget.equals("1")) {
            RecordSetTrans.executeSql("exec sp_rename '"+inprepbugtablename+"."+olditemfieldname+"', '"+itemfieldname+"', 'column' "); 
        }

        if(inprepforecast.equals("1")) {
            RecordSetTrans.executeSql("exec sp_rename '"+inpreptablename+"_forecast."+olditemfieldname+"', '"+itemfieldname+"', 'column' "); 
        }
*/
    }

    
    if(totaldetail !=0) {
        RecordSetTrans.executeProc("T_InputReportItemDetail_Delete",itemid);
        RecordSetTrans.executeSql("delete from workflow_selectitem where fieldId="+fieldId+" and isBill=1 ");
        for( int i =0 ; i< totaldetail ; i++) {
//            String itemdsp = Util.fromScreen(request.getParameter("itemdsp"+i),user.getLanguage());
//            String itemvalue = Util.fromScreen(request.getParameter("itemvalue"+i),user.getLanguage());
//            String itemdsp = itemvalue ;
//
//            if(!itemvalue.equals("")) {
//                para = itemid + separator + itemdsp + separator + itemvalue ;
//                RecordSetTrans.executeProc("T_InputReportItemDetail_Insert",para);
//            }

            String itemdsp = Util.fromScreen(request.getParameter("itemdsp"+i),user.getLanguage());
            int itemvalue = Util.getIntValue(request.getParameter("itemvalue"+i),-1);
			if(!itemdsp.equals("")){
				if(itemvalue<0){
					RecordSetTrans.executeSql("select max(itemValue) as maxItemValue from T_InputReportItemDetail where itemId="+itemid);
					if(RecordSetTrans.next()){
						itemvalue=Util.getIntValue(RecordSetTrans.getString("maxItemValue"),-1);
					}
					itemvalue++;
				}
                para = itemid + separator + itemdsp + separator + itemvalue ;
                RecordSetTrans.executeProc("T_InputReportItemDetail_Insert",para);
				para=""+fieldId+separator+"1"+separator+""+itemvalue+separator+itemdsp+separator+i+separator+"n";
				RecordSetTrans.executeProc("workflow_SelectItem_Insert",para);
			}
        }
    }
	RecordSetTrans.commit();
    LabelComInfo.addLabeInfoCache(String.valueOf(fieldLabel));
  }catch(Exception exception){
	  RecordSetTrans.rollback();
  }
    //InputReportModuleFile.createModuleFile(""+inprepid,user) ;

    response.sendRedirect("InputReportEdit.jsp?inprepid=" + inprepid);

 }
 else if(operation.equals("delete")){
  try{
	String tempItemFieldName="";
	RecordSetTrans.executeSql("select itemFieldName from T_InputReportItem  where itemId="+itemid);
	if(RecordSetTrans.next()){
		tempItemFieldName=Util.null2String(RecordSetTrans.getString("itemFieldName"));
	}
	int fieldId=0;
	RecordSetTrans.executeSql("select id from workflow_billfield where billId="+billId+" and fieldName='"+tempItemFieldName+"'");
	if(RecordSetTrans.next()){
		fieldId=Util.getIntValue(RecordSetTrans.getString("id"),0);
	}

	if(fieldId>0){
		    String nodeLinkIdS="";
			String sql="select t1.id from workflow_nodelink t1, workflow_base t2 where EXISTS(select 1 from workflow_nodebase b where t1.nodeid=b.id and (b.IsFreeNode is null or b.IsFreeNode !='1')) and EXISTS(select 1 from workflow_nodebase b where t1.destnodeid=b.id and (b.IsFreeNode is null or b.IsFreeNode !='1')) and t1.wfrequestid is null and t1.workflowid=t2.id and t2.isbill='1' and t2.formid=" + billId + " and t1.condition like '%"+tempItemFieldName+"%'";
			RecordSetTrans.execute(sql);
			while(RecordSetTrans.next()){
				nodeLinkIdS += RecordSetTrans.getString("id") + "," ;
			}
		    if(!nodeLinkIdS.equals("")){
			    nodeLinkIdS = nodeLinkIdS.substring(0,nodeLinkIdS.lastIndexOf(","));
			    response.sendRedirect("/workflow/workflow/BillManagementFieldDelCheck.jsp?actionType=delete&billId=" + billId+"&fieldIds="+fieldId) ;
			    return;		
		    }else{
				
				String fieldName="";
				String fieldHtmlType="";
				//获得字段名
				sql = "select fieldname , fieldhtmltype from  workflow_billfield where id = " + fieldId ;	
				RecordSetTrans.execute(sql) ;
				if(RecordSetTrans.next()){
					fieldName = RecordSetTrans.getString("fieldname") ;	
					fieldHtmlType = Util.null2String(RecordSetTrans.getString("fieldhtmltype")) ;	
				}
				
				
				//删除节点附加操作
				boolean delSuccess=true;
				if(delSuccess){
					sql = "delete from  workflow_addinoperate where isnode=1 and objid in (select t1.nodeid from  workflow_flownode t1, workflow_base t2 where t1.workflowid=t2.id and t2.isbill='1' and t2.formid=" + billId + ") and (fieldid =" + fieldId + " or fieldop1id = " + fieldId + " or fieldop2id = " + fieldId + ")" ;
					delSuccess = RecordSetTrans.execute(sql) ;
				}
				
				//删除出口附加操作
				
				if(delSuccess){
					sql = "delete from  workflow_addinoperate where isnode=0 and objid in (select t1.id from  workflow_nodelink t1, workflow_base t2 where t1.workflowid=t2.id and t2.isbill='1' and t2.formid=" + billId + ") and (fieldid =" + fieldId + " or fieldop1id = " + fieldId + " or fieldop2id = " + fieldId + ")" ;
					delSuccess = RecordSetTrans.execute(sql) ;
				}
						
	
				
				//删除由自定义字段产生的操作人，主要是由浏览框带来的
				/*
				*5：人力资源字段本人
				*6：人力资源字段经理 
				*31：人力资源字段下属 
				*32：人力资源字段本分部+ 安全级别
				*7：人力资源字段本部门 + 安全级别
				*38：人力资源字段上级部门+ 安全级别	
				*42：部门
				*43：角色
				*8：文档字段所有者，选择的文档字段对应值所代表的文档的所有者
				*33：文档字段分部+ 安全级别
				*9：文档字段部门+ 安全级别
				*10：项目字段经理，选择的项目字段对应值所代表的项目的经理
				*47：项目字段经理的经理
				*34：项目字段分部+ 安全级别
				*11：项目字段部门+ 安全级别
				*12：项目字段成员+ 安全级别
				*13：资产字段管理员
				*35：资产字段分部+ 安全级别
				*14：资产字段部门+ 安全级别
				*15：客户字段经理 ，选择的客户字段对应值所代表的客户的经理
				*44：客户字段经理的经理
				*45：客户字段分部
				*46：客户字段部门
				*16：客户字段联系人经理 	
				*/
				if(delSuccess){
					sql = "delete from  workflow_groupdetail where type in(5,6,31,32,7,38,42,43,8,33,9,10,47,34,11,12,13,35,14,15,44,45,46,16) and groupid in(select id from workflow_nodegroup where nodeid in (select t1.nodeid from  workflow_flownode t1, workflow_base t2 where t1.workflowid=t2.id and t2.isbill='1' and t2.formid=" + billId + ")) and objid=" + fieldId;
					delSuccess = RecordSetTrans.execute(sql) ;	
				}
				
				//删除节点上哪些字段可视、可编辑、必输的信息
				if(delSuccess){
					sql = "delete from  workflow_nodeform where nodeid in (select t1.nodeid from  workflow_flownode t1, workflow_base t2 where t1.workflowid=t2.id and t2.isbill='1' and t2.formid=" + billId + ") and fieldid= " + fieldId ;	
					delSuccess = RecordSetTrans.execute(sql) ;	
				}
				
				//删除字段类型为选择框的所有选择项信息
				if(delSuccess && (fieldHtmlType.equals("5"))){
					sql = "delete from  workflow_selectitem where isbill=1 and fieldid =" + fieldId ;
					delSuccess = RecordSetTrans.execute(sql) ;
				}
				
				//删除记录单据字段信息
				if(delSuccess){
					sql = "delete from  workflow_billfield where id = " + fieldId ;		
					delSuccess = RecordSetTrans.execute(sql) ;
				}				
		    }
	}


    char separator = Util.getSeparator() ;
	String para = ""+itemid;
	RecordSetTrans.executeProc("T_InputReportItem_Delete",para);
    RecordSetTrans.executeProc("T_InputReportItemDetail_Delete",para);

    RecordSetTrans.executeSql ( "ALTER TABLE "+ inpreptablename +" DROP COLUMN " + olditemfieldname );


    if(inprepbudget.equals("1")) {
		RecordSetTrans.executeSql ( "ALTER TABLE "+ inprepbugtablename +" DROP COLUMN " + olditemfieldname );	
    }

    if(inprepforecast.equals("1")) {
		RecordSetTrans.executeSql ( "ALTER TABLE "+ inpreptablename +"_forecast DROP COLUMN " + olditemfieldname );
    }
	RecordSetTrans.commit();
  }catch(Exception exception){
	  RecordSetTrans.rollback();
  }
    //InputReportModuleFile.createModuleFile(""+inprepid,user) ;

    response.sendRedirect("InputReportEdit.jsp?inprepid=" + inprepid);
 }
 else if(operation.equals("addclose")){
    char separator = Util.getSeparator() ;
	String para = inprepid + separator + itemid + separator + crmid ;
	RecordSet.executeProc("T_InputReportItemClose_Insert",para);

    response.sendRedirect("InputReportItemClose.jsp?inprepid=" + inprepid);
 }
 else if(operation.equals("deleteclose")){
	RecordSet.executeProc("T_InputReportItemClose_Delete",closeid);

    response.sendRedirect("InputReportItemClose.jsp?inprepid=" + inprepid);
 }
%>
