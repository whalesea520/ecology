<%@ page import = "weaver.general.Util" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file = "/systeminfo/init_wev8.jsp" %>

<jsp:useBean id = "RecordSet" class = "weaver.conn.RecordSet" scope = "page" />
<jsp:useBean id = "RecordSet1" class = "weaver.conn.RecordSet" scope = "page"/>
<jsp:useBean id = "RecordSet2" class = "weaver.conn.RecordSet" scope = "page"/>
<jsp:useBean id = "SalaryComInfo" class = "weaver.hrm.finance.SalaryComInfo" scope = "page" />
<jsp:useBean id = "SalaryManager" class = "weaver.hrm.finance.SalaryManager" scope = "page" />

<%
char flag = Util.getSeparator() ; 
String ProcPara = "" ; 
String method = request.getParameter("method") ; 
String id = Util.null2String(request.getParameter("id")) ; 

String itemname = Util.fromScreen(request.getParameter("itemname") , user.getLanguage()) ; //工资项名称
String itemcode = Util.null2String(request.getParameter("itemcode")) ; //工资项代码
String itemtype = Util.null2String(request.getParameter("itemtype")) ; //项目类型
String olditemtype = Util.null2String(request.getParameter("olditemtype")) ; //

String personwelfarerate = "" + Util.getIntValue(request.getParameter("personwelfarerate") , 0) ; //福利个人费率
String companywelfarerate = "" + Util.getIntValue(request.getParameter("companywelfarerate") , 0) ; //福利公司费率
String taxrelateitem = ""+Util.getIntValue(request.getParameter("taxrelateitem") , 0) ; //税收基准项目
String amountecp = Util.null2String(request.getParameter("amountecp")) ; //计算公式

String feetype = "" + Util.getIntValue(request.getParameter("feetype") , 0) ; //费用类型
String isshow = "" + Util.getIntValue(request.getParameter("isshow") , 0) ; //是否显示
String showorder = "" + Util.getIntValue(request.getParameter("showorder") , 0) ; //显示顺序
String ishistory = "" + Util.getIntValue(request.getParameter("ishistory") , 0) ; //是否记录历史变动
String calMode = Util.null2String(request.getParameter("calMode")) ;
String directModify = Util.null2String(request.getParameter("directModify")) ;
String companyPercent = Util.null2String(request.getParameter("companyPercent")) ;
String personalPercent = Util.null2String(request.getParameter("personalPercent")) ;

int totalje = Util.getIntValue(request.getParameter("totalje") , 0) ; //计算
int totalfl = Util.getIntValue(request.getParameter("totalfl") , 0) ; //福利
int totalss = Util.getIntValue(request.getParameter("totalss") , 0) ; //税收
int totalkqkk = Util.getIntValue(request.getParameter("totalkqkk") , 0) ; //考勤扣款
int totalkqjx = Util.getIntValue(request.getParameter("totalkqjx") , 0) ; //考勤加薪
String totalssd = Util.null2String(request.getParameter("totalssd")) ; //工资
int totalcal = Util.getIntValue(request.getParameter("totalcal") , 0)  ;  //计算
String totalcald = Util.null2String(request.getParameter("totalcald")) ;  //计算
int totalwel = Util.getIntValue(request.getParameter("totalwel") , 0)  ;  //福利计算
String totalweld = Util.null2String(request.getParameter("totalweld")) ;  //福利计算
String subcompanyid = Util.null2String(request.getParameter("subcompanyid")) ;//所属分部
String applyscope = Util.null2String(request.getParameter("applyscope")) ;  //应用范围
    //System.out.println("totalcal"+totalcal);
    //System.out.println("totalcald"+totalcald);
if( isshow.equals("0") && "0".equals(showorder.trim())) showorder = "9999" ; 

if (method.equals("add")) { 
    if( itemtype.equals("4")) {
        String temprepcode = "$Tempcode99$" ; 
        RecordSet.executeSql("select itemcode from HrmSalaryItem") ; 
        while( RecordSet.next()){ 
            String tempitemcode = Util.null2String(RecordSet.getString(1)) ; 
            amountecp = Util.StringReplace(amountecp , tempitemcode , temprepcode) ; 
            amountecp = Util.StringReplace(amountecp , temprepcode , "$" + tempitemcode) ; 
        }
    }

	ProcPara = itemname ; 
    ProcPara += flag + itemcode ; 
    ProcPara += flag + itemtype ; 
    ProcPara += flag + personwelfarerate ; 
    ProcPara += flag + companywelfarerate ; 
    ProcPara += flag + taxrelateitem ; 
    ProcPara += flag + amountecp ; 
    ProcPara += flag + feetype ; 
	ProcPara += flag + isshow ; 
	ProcPara += flag + showorder ; 
    ProcPara += flag + ishistory ; 
    ProcPara += flag + subcompanyid ;
    ProcPara += flag + applyscope ;
    ProcPara += flag + calMode ;
    ProcPara += flag + directModify ;
    ProcPara += flag + personalPercent ;
    ProcPara += flag + companyPercent ;

    RecordSet.executeProc("HrmSalaryItem_Insert" , ProcPara) ; 
    if( RecordSet.next()) id = Util.null2String(RecordSet.getString(1)) ; 

    if(itemtype.equals("1") || itemtype.equals("2")){ 
        for( int i=0 ; i < totalje ; i++){
            String jobactivityid = "" + Util.getIntValue(request.getParameter("jobactivityid" + i) , 0) ; 
            String jobid = "" + Util.getIntValue(request.getParameter("jobid" + i) , 0) ; 
            String joblevelfrom = "" + Util.getIntValue(request.getParameter("joblevelfrom" + i) , 0) ; 
            String joblevelto = "" + Util.getIntValue(request.getParameter("joblevelto" + i) , 0) ; 
            String amount = Util.null2String(request.getParameter("amount" + i)) ; 
            if( Util.getDoubleValue(amount , 0) == 0)
               continue ; 

            ProcPara =  id ; 
            ProcPara += flag + jobid ; 
            ProcPara += flag + joblevelfrom ; 
            ProcPara += flag + joblevelto ; 
            ProcPara += flag + amount ; 
            ProcPara += flag + jobactivityid ; 
            RecordSet.executeProc("HrmSalaryRank_Insert" , ProcPara) ; 
        }

        if( itemtype.equals("2")){ 
            for( int i=0 ; i < totalfl ; i++){ 
                String ratecityid = "" + Util.getIntValue(request.getParameter("ratecityid" + i) , 0) ; 
                String thepersonwelfarerate = "" + Util.getDoubleValue(request.getParameter("personwelfarerate" + i) , 0) ; 
                String thecompanywelfarerate = "" + Util.getDoubleValue(request.getParameter("companywelfarerate" + i) , 0);
                
                if( Util.getDoubleValue(thepersonwelfarerate , 0) == 0 || Util.getDoubleValue(thecompanywelfarerate , 0) == 0) continue ; 

                ProcPara =  id ; 
                ProcPara += flag + ratecityid ; 
                ProcPara += flag + thepersonwelfarerate ; 
                ProcPara += flag + thecompanywelfarerate ; 
                RecordSet.executeProc("HrmSalaryWelfarerate_Insert" , ProcPara);   
            }
        }

        // 增加个人基准设置部分
        RecordSet.executeSql(" select id from Hrmresource where status in (0,1,2,3) ") ; 	
        while(RecordSet.next()){ 
            String resourceid = Util.null2String( RecordSet.getString("id") ) ; 
            String resourcepay = Util.null2String(request.getParameter("resource_" + resourceid)) ;  
            if(Util.getDoubleValue(resourcepay,0) == 0 ) continue ; 
            ProcPara = id ; 
            ProcPara += flag + resourceid + flag + resourcepay + flag + "0"   ; 
            RecordSet.executeProc("HrmSalaryResourcePay_Insert" , ProcPara) ;

            // 将值直接设置到这个人的基准中
            RecordSet.executeSql(" delete from HrmSalaryPersonality where hrmid = " + resourceid + " and itemid = " + id ) ;
            RecordSet.executeSql(" insert into HrmSalaryPersonality (itemid, hrmid, salary) " +
                          " values (" + id + "," + resourceid + "," + resourcepay + ")" ) ;
            
        }
    }
    else if( itemtype.equals("3")){ 
        String[] totalssds = Util.TokenizerString2( totalssd , "," ) ;
        for( int i=0 ; i < totalss ; i++){//
            String cityid1 =Util.null2String(request.getParameter("cityid" + i));
            String scopetype = Util.null2String(request.getParameter("scopetype" + i)) ;
            String taxbenchmark = "" + Util.getIntValue(request.getParameter("taxbenchmark" + i) , 0) ; 
            if( Util.getIntValue(taxbenchmark , 0 ) == 0)
                continue ;
            String cityid="";
            if(scopetype.equals("1"))
            cityid=cityid1;
            ProcPara =  id ; 
            ProcPara += flag + cityid ; 
            ProcPara += flag + taxbenchmark ; 
            RecordSet.executeProc("HrmSalaryTaxbench_Insert",ProcPara); 
            String benchid = "0" ; 
            if(RecordSet.next()) benchid = Util.null2String(RecordSet.getString(1)) ; 
                for(int j=0 ; j < Util.getIntValue(totalssds[i] , 0) ; j++){
                String ranknum = "" + Util.getIntValue(request.getParameter("ranknum" + i + "_" + j) , 0) ; 
                String ranklow = "" + Util.getIntValue(request.getParameter("ranklow" + i + "_" + j) , 0) ; 
                String rankhigh = "" + Util.getIntValue(request.getParameter("rankhigh" + i + "_" + j) , 0) ; 
                String taxrate = "" + Util.getIntValue(request.getParameter("taxrate" + i + "_" + j) , 0) ;
                String subtractnum = "" + Util.getIntValue(request.getParameter("subtractnum" + i + "_" + j) , 0) ;
//qc219690解决 税收项 含税级距(从)字段 为0的时候，保存不上的问题
                if(ranknum.equals("0") || taxrate.equals("0"))
                    continue ; 

                ProcPara =  benchid ; 
                ProcPara += flag + ranknum ; 
                ProcPara += flag + ranklow ; 
                ProcPara += flag + rankhigh ; 
                ProcPara += flag + taxrate ;
                ProcPara += flag + subtractnum ;
                RecordSet.executeProc("HrmSalaryTaxrate_Insert" , ProcPara) ; 
            }
            //System.out.println("scopetype"+scopetype);
            //System.out.println("cityid"+cityid1);
            if(scopetype.equals("0")){
                //System.out.println("insert into HrmSalaryTaxscope(benchid,scopetype) values("+benchid+","+scopetype+")");
                RecordSet.executeSql("insert into HrmSalaryTaxscope(itemid,benchid,scopetype) values("+id+","+benchid+","+scopetype+")");
            }else{
            ArrayList l=Util.TokenizerString(cityid1,",");
            for(Iterator iter=l.iterator();iter.hasNext();){
                String objectid=(String)iter.next();
                //System.out.println("insert into HrmSalaryTaxscope(benchid,scopetype,objectid) values("+benchid+","+scopetype+","+objectid+")");
                RecordSet.executeSql("insert into HrmSalaryTaxscope(itemid,benchid,scopetype,objectid) values("+id+","+benchid+","+scopetype+","+objectid+")");
            }
            }
        }
    }
    else if( itemtype.equals("4")){
        String[] totalcals = Util.TokenizerString2( totalcald , "," ) ;
        for( int i=0 ; i < totalcal ; i++){//
            String objectid1 =Util.null2String(request.getParameter("objectidcal" + i));
            String scopetype = Util.null2String(request.getParameter("scopetypecal" + i)) ;
            //System.out.println("objectid"+objectid1);
            if( scopetype.equals(""))
                continue ;
            String objectid="";
            if(scopetype.equals("1"))
            objectid=objectid1;
            ProcPara =  id ;
            ProcPara += flag + scopetype ;
            RecordSet.executeProc("HrmSalaryCalBench_Insert",ProcPara);
            String benchid = "0" ;
            if(RecordSet.next()) benchid = Util.null2String(RecordSet.getString(1)) ;
                for(int j=0 ; j < Util.getIntValue(totalcals[i] , 0) ; j++){
                String timescope = "" + Util.getIntValue(request.getParameter("timescopecal" + i + "_" + j) , 0) ;
                String condition = "" + Util.null2String(request.getParameter("concal" + i + "_" + j) ) ;
                String formula = "" + Util.null2String(request.getParameter("formulacal" + i + "_" + j) ) ;
                String conditiondsp = "" + Util.null2String(request.getParameter("condspcal" + i + "_" + j) ) ;
                String formuladsp = "" + Util.null2String(request.getParameter("formuladspcal" + i + "_" + j) ) ;

                if(formula.equals(""))
                    continue ;

                ProcPara =  benchid ;
                ProcPara += flag + timescope ;
                ProcPara += flag + condition ;
                ProcPara += flag + formula ;
                ProcPara += flag + conditiondsp ;
                ProcPara += flag + formuladsp ;

                RecordSet.executeProc("HrmSalaryCalrate_Insert" , ProcPara) ;
            }
            //System.out.println("scopetype"+scopetype);
            //System.out.println("cityid"+cityid1);
            if(scopetype.equals("0")){
                //System.out.println("insert into HrmSalaryTaxscope(benchid,scopetype) values("+benchid+","+scopetype+")");
                RecordSet.executeSql("insert into HrmSalaryCalScope(itemid,benchid,objectid) values("+id+","+benchid+",-1)");
            }else{
            ArrayList l=Util.TokenizerString(objectid1,",");
            for(Iterator iter=l.iterator();iter.hasNext();){
                String theobjectid=(String)iter.next();
                //System.out.println("insert into HrmSalaryCalScope(itemid,benchid,objectid) values("+id+","+benchid+","+theobjectid+")");
                RecordSet.executeSql("insert into HrmSalaryCalScope(itemid,benchid,objectid) values("+id+","+benchid+","+theobjectid+")");
            }
            }
        }
    }
    else if(itemtype.equals("5")){

        for(int i=0 ; i < totalkqkk ; i++){
            String diffid = Util.null2String(request.getParameter("diffnamekk" + i)) ;  
            if(diffid.equals("")) continue ; 
            ProcPara = id ; 
            ProcPara += flag + diffid ; 
            RecordSet.executeProc("HrmSalaryScheduleDec_Insert" , ProcPara) ;    
        }
    }
    
    else if(itemtype.equals("6")){
      
        for(int i=0 ; i < totalkqjx ; i++){
            String diffid = Util.null2String(request.getParameter("diffnamejx" + i)) ;  
            if(diffid.equals("")) continue ; 
            ProcPara = id ; 
            ProcPara += flag + diffid ; 
            RecordSet.executeProc("HrmSalaryScheduleAdd_Insert" , ProcPara) ;    
        }
    }

    else if(itemtype.equals("7")){
        RecordSet.executeProc("HrmArrangeShift_SelectAll" , "0") ; 	
	    while(RecordSet.next()){ 
            String shiftid = Util.null2String( RecordSet.getString("id") ) ; 
            String shiftpay = Util.null2String(request.getParameter("shift" + shiftid)) ;  
            if(Util.getDoubleValue(shiftpay,0) == 0 ) continue ; 
            ProcPara = id ; 
            ProcPara += flag + shiftid + flag + shiftpay  ; 
            RecordSet.executeProc("HrmSalaryShiftPay_Insert" , ProcPara) ;    
        }
        
        // 对一般工作时间
        String shiftpay = Util.null2String(request.getParameter("shift0")) ;  
        if(Util.getDoubleValue(shiftpay,0) != 0 ) {
            ProcPara = id ; 
            ProcPara += flag + "0" + flag + shiftpay  ; 
            RecordSet.executeProc("HrmSalaryShiftPay_Insert" , ProcPara) ; 
        }
    }

    else if(itemtype.equals("8")){
        RecordSet.executeSql(" select id from Hrmresource where status in (0,1,2,3) ") ; 	
	    while(RecordSet.next()){ 
            String resourceid = Util.null2String( RecordSet.getString("id") ) ; 
            String resourcepay = Util.null2String(request.getParameter("resource_" + resourceid)) ;  
            if(Util.getDoubleValue(resourcepay,0) == 0 ) continue ; 
            ProcPara = id ; 
            ProcPara += flag + resourceid + flag + resourcepay + flag + "0"   ; 
            RecordSet.executeProc("HrmSalaryResourcePay_Insert" , ProcPara) ;    
        }
    }
     else if( itemtype.equals("9")){
        String[] totalwels = Util.TokenizerString2( totalweld , "," ) ;
        //System.out.println("totalwel"+totalwel);
        for( int i=0 ; i < totalwel ; i++){//
            String objectid1 =Util.null2String(request.getParameter("objectidwel" + i));
            String scopetype = Util.null2String(request.getParameter("scopetypewel" + i)) ;

            if( scopetype.equals(""))
                continue ;
            String objectid="";
            if(scopetype.equals("1"))
            objectid=objectid1;
            ProcPara =  id ;
            ProcPara += flag + scopetype ;
            RecordSet.executeProc("HrmSalaryCalBench_Insert",ProcPara);
            String benchid = "0" ;
            if(RecordSet.next()) benchid = Util.null2String(RecordSet.getString(1)) ;
                for(int j=0 ; j < Util.getIntValue(totalwels[i] , 0) ; j++){
                String timescope = "" + Util.getIntValue(request.getParameter("timescopewel" + i + "_" + j) , 0) ;
                String condition = "" + Util.null2String(request.getParameter("conwel" + i + "_" + j) ) ;
                String formula = "" + Util.null2String(request.getParameter("formulawel" + i + "_" + j) ) ;
                String conditiondsp = "" + Util.null2String(request.getParameter("condspwel" + i + "_" + j) ) ;
                String formuladsp = "" + Util.null2String(request.getParameter("formuladspwel" + i + "_" + j) ) ;

                if(formula.equals(""))
                    continue ;
              
                ProcPara =  benchid ;
                ProcPara += flag + timescope ;
                ProcPara += flag + condition ;
                ProcPara += flag + formula ;
                ProcPara += flag + conditiondsp ;
                ProcPara += flag + formuladsp ;
                RecordSet.executeProc("HrmSalaryCalrate_Insert" , ProcPara) ;
            }
            //System.out.println("scopetype"+scopetype);
            //System.out.println("cityid"+cityid1);
            if(scopetype.equals("0")){
                //System.out.println("insert into HrmSalaryTaxscope(benchid,scopetype) values("+benchid+","+scopetype+")");
                RecordSet.executeSql("insert into HrmSalaryCalScope(itemid,benchid,objectid) values("+id+","+benchid+",-1)");
            }else{
            ArrayList l=Util.TokenizerString(objectid1,",");
            for(Iterator iter=l.iterator();iter.hasNext();){
                String theobjectid=(String)iter.next();
                //System.out.println("insert into HrmSalaryCalScope(itemid,benchid,objectid) values("+id+","+benchid+","+theobjectid+")");
                RecordSet.executeSql("insert into HrmSalaryCalScope(itemid,benchid,objectid) values("+id+","+benchid+","+theobjectid+")");
            }
            }
        }
    }

}

if (method.equals("edit")){
	if( itemtype.equals("4")){
        String temprepcode = "$Tempcode99$" ; 
        RecordSet.executeSql("select itemcode from HrmSalaryItem") ; 
        while(RecordSet.next()){
            String tempitemcode = Util.null2String(RecordSet.getString(1)) ; 
            amountecp = Util.StringReplace(amountecp , tempitemcode , temprepcode) ; 
            amountecp = Util.StringReplace(amountecp , temprepcode , "$" + tempitemcode) ; 
        } 
    } 

	ProcPara =  id ; 
    ProcPara += flag + itemname ; 
    ProcPara += flag + itemcode ; 
    ProcPara += flag + itemtype ; 
    ProcPara += flag + personwelfarerate ; 
    ProcPara += flag + companywelfarerate ; 
    ProcPara += flag + taxrelateitem ; 
    ProcPara += flag + amountecp ; 
    ProcPara += flag + feetype ; 
	ProcPara += flag + isshow ; 
	ProcPara += flag + showorder ; 
    ProcPara += flag + ishistory ; 
    ProcPara += flag + applyscope ;
    ProcPara += flag + calMode ;
    ProcPara += flag + directModify ;
    ProcPara += flag + personalPercent ;
    ProcPara += flag + companyPercent ;
    RecordSet.executeProc("HrmSalaryItem_Update" , ProcPara) ;

    if(itemtype.equals("1") || itemtype.equals("2")){
        for(int i=0 ; i < totalje ; i++){
            String jobactivityid = "" + Util.getIntValue(request.getParameter("jobactivityid" + i) , 0) ; 
            String jobid = ""+Util.getIntValue(request.getParameter("jobid" + i) , 0) ; 
            String joblevelfrom = ""+Util.getIntValue(request.getParameter("joblevelfrom" + i) , 0) ; 
            String joblevelto = ""+Util.getIntValue(request.getParameter("joblevelto" + i) , 0) ; 
            String amount = Util.null2String(request.getParameter("amount" + i)) ; 
            if( Util.getDoubleValue(amount , 0) == 0) continue ; 

            ProcPara =  id ; 
            ProcPara += flag + jobid ; 
            ProcPara += flag + joblevelfrom ; 
            ProcPara += flag + joblevelto ; 
            ProcPara += flag + amount ; 
            ProcPara += flag + jobactivityid ; 
            RecordSet.executeProc("HrmSalaryRank_Insert" , ProcPara) ;    
        }

        if(itemtype.equals("2")){
            for(int i=0 ; i < totalfl ; i++){
                String ratecityid = "" + Util.getIntValue(request.getParameter("ratecityid" + i) , 0) ; 
                String thepersonwelfarerate = "" + Util.getDoubleValue(request.getParameter("personwelfarerate" + i) , 0) ; 
                String thecompanywelfarerate = "" + Util.getDoubleValue(request.getParameter("companywelfarerate" + i) , 0) ;
                
                if( Util.getDoubleValue(thepersonwelfarerate , 0) == 0 || Util.getDoubleValue(thecompanywelfarerate , 0) == 0) continue ; 

                ProcPara =  id ;
                ProcPara += flag + ratecityid ; 
                ProcPara += flag + thepersonwelfarerate ; 
                ProcPara += flag + thecompanywelfarerate ; 
                RecordSet.executeProc("HrmSalaryWelfarerate_Insert",ProcPara) ;
            }
        }

        if(!olditemtype.equals(itemtype)){
            RecordSet.executeSql(" delete from HrmSalaryPersonality where itemid = " + id ) ; 
        }

        // 增加个人基准设置部分
        RecordSet.executeSql(" select id from Hrmresource where status in (0,1,2,3) ") ; 	
        while(RecordSet.next()){ 
            String resourceid = Util.null2String( RecordSet.getString("id") ) ; 
            String resourcepay = Util.null2String(request.getParameter("resource_" + resourceid)) ; 
            String resourcepay_oldpay = Util.null2String(request.getParameter("resource_" + resourceid + "_oldpay")) ; 
            if(Util.getDoubleValue(resourcepay,0) != 0 )  {
                ProcPara = id ; 
                ProcPara += flag + resourceid + flag + resourcepay + flag + "0"   ; 
                RecordSet.executeProc("HrmSalaryResourcePay_Insert" , ProcPara) ;  
            }
            
            if(Util.getDoubleValue(resourcepay,0) != Util.getDoubleValue(resourcepay_oldpay,0))  {
                // 将值直接设置到这个人的基准中
                RecordSet.executeSql(" delete from HrmSalaryPersonality where hrmid = " + resourceid + " and itemid = " + id ) ;
                if(Util.getDoubleValue(resourcepay,0) != 0 )  {
                    RecordSet.executeSql(" insert into HrmSalaryPersonality (itemid, hrmid, salary) " +
                              " values (" + id + "," + resourceid + "," + resourcepay + ")" ) ;
                }
            }
        }
    }
    else if(itemtype.equals("3") ) {      
        String[] totalssds = Util.TokenizerString2( totalssd , "," ) ; 
        for(int i=0 ; i < totalss ; i++){
            String cityid1 = Util.null2String(request.getParameter("cityid" + i))  ;
            String taxbenchmark = "" + Util.getIntValue(request.getParameter("taxbenchmark" + i) , 0) ;
            String scopetype = Util.null2String(request.getParameter("scopetype" + i)) ;
            if(Util.getIntValue(taxbenchmark,0 ) == 0) continue ; 
            String cityid="";
            if(scopetype.equals("1"))
            cityid=cityid1;
            ProcPara =  id ; 
            ProcPara += flag + cityid ; 
            ProcPara += flag + taxbenchmark ; 
            RecordSet.executeProc("HrmSalaryTaxbench_Insert" , ProcPara) ; 
            String benchid = "0" ; 
            if(RecordSet.next()) benchid = Util.null2String(RecordSet.getString(1)) ; 
            
            for(int j=-1 ; j < Util.getIntValue(totalssds[i] , 0) ; j++){
                String ranknum = "" + Util.getIntValue(request.getParameter("ranknum" + i + "_" + j) , 0) ; 
                String ranklow = "" + Util.getIntValue(request.getParameter("ranklow" + i + "_" + j) , 0) ; 
                String rankhigh = "" + Util.getIntValue(request.getParameter("rankhigh" + i + "_" + j) , 0) ; 
                String taxrate = "" + Util.getIntValue(request.getParameter("taxrate" + i + "_" + j) , 0) ; 
                String subtractnum = "" + Util.getIntValue(request.getParameter("subtractnum" + i + "_" + j) , 0) ;
//qc219690解决 税收项 含税级距(从)字段 为0的时候，保存不上的问题
                if(ranknum.equals("0") || taxrate.equals("0")) continue ; 

                ProcPara =  benchid ; 
                ProcPara += flag + ranknum ; 
                ProcPara += flag + ranklow ; 
                ProcPara += flag + rankhigh ; 
                ProcPara += flag + taxrate ;
                ProcPara += flag + subtractnum ; 
                RecordSet.executeProc("HrmSalaryTaxrate_Insert",ProcPara) ;
            }
            if(scopetype.equals("0")){
                //System.out.println("insert into HrmSalaryTaxscope(benchid,scopetype) values("+benchid+","+scopetype+")");
                RecordSet.executeSql("insert into HrmSalaryTaxscope(itemid,benchid,scopetype) values("+id+","+benchid+","+scopetype+")");
            }else{
            ArrayList l=Util.TokenizerString(cityid1,",");
            for(Iterator iter=l.iterator();iter.hasNext();){
                String objectid=(String)iter.next();
                //System.out.println("insert into HrmSalaryTaxscope(benchid,scopetype,objectid) values("+benchid+","+scopetype+","+objectid+")");
                RecordSet.executeSql("insert into HrmSalaryTaxscope(itemid,benchid,scopetype,objectid) values("+id+","+benchid+","+scopetype+","+objectid+")");
            }
            }
        }
    }
    else if(itemtype.equals("4") ) {
        String[] totalcalds = Util.TokenizerString2( totalcald , "," ) ;
        for(int i=0 ; i < totalcal ; i++){
            String objectid1 = Util.null2String(request.getParameter("objectidcal" + i))  ;
            String scopetype = Util.null2String(request.getParameter("scopetypecal" + i)) ;
            //System.out.println("objectid"+objectid1);
            if( scopetype.equals(""))
                continue ;

            String objectid="";
            if(scopetype.equals("1"))
            objectid=objectid1;
            ProcPara =  id ;
            ProcPara += flag + scopetype ;
            RecordSet.executeProc("HrmSalaryCalBench_Insert",ProcPara);
            String benchid = "0" ;
            if(RecordSet.next()) benchid = Util.null2String(RecordSet.getString(1)) ;

            for(int j=0 ; j < Util.getIntValue(totalcalds[i] , 0) ; j++){
                 String timescope = "" + Util.getIntValue(request.getParameter("timescopecal" + i + "_" + j) , 0) ;
                String condition = "" + Util.null2String(request.getParameter("concal" + i + "_" + j) ) ;
                String formula = "" + Util.null2String(request.getParameter("formulacal" + i + "_" + j) ) ;
                String conditiondsp = "" + Util.null2String(request.getParameter("condspcal" + i + "_" + j) ) ;
                String formuladsp = "" + Util.null2String(request.getParameter("formuladspcal" + i + "_" + j) ) ;

                if(formula.equals(""))
                    continue ;

                ProcPara =  benchid ;
                ProcPara += flag + timescope ;
                ProcPara += flag + condition ;
                ProcPara += flag + formula ;
                ProcPara += flag + conditiondsp ;
                ProcPara += flag + formuladsp ;
                RecordSet.executeProc("HrmSalaryCalRate_Insert" , ProcPara) ;
            }
           if(scopetype.equals("0")){
                //System.out.println("insert into HrmSalaryTaxscope(benchid,scopetype) values("+benchid+","+scopetype+")");
                RecordSet.executeSql("insert into HrmSalaryCalScope(itemid,benchid,objectid) values("+id+","+benchid+",-1)");
            }else{
            ArrayList l=Util.TokenizerString(objectid1,",");
            for(Iterator iter=l.iterator();iter.hasNext();){
                String theobjectid=(String)iter.next();
                //System.out.println("insert into HrmSalaryCalScope(itemid,benchid,objectid) values("+id+","+benchid+","+theobjectid+")");
                RecordSet.executeSql("insert into HrmSalaryCalScope(itemid,benchid,objectid) values("+id+","+benchid+","+theobjectid+")");
            }
            }
        }
    }
    else if(itemtype.equals("5")) {
        for(int i=0 ; i < totalkqkk ; i++) {
            String diffid = "" + Util.getIntValue(request.getParameter("diffname01" + i) , 0) ;  
                            
            if(diffid.equals("0")) continue ; 
           
            ProcPara = id ; 
            ProcPara += flag + diffid ; 
            RecordSet.executeProc("HrmSalaryScheduleDec_Insert" , ProcPara) ;    
        }
    }

    else if(itemtype.equals("6")){
        for(int i=0 ; i < totalkqjx ; i++) {
            String diffid = "" + Util.getIntValue(request.getParameter("diffname0" + i) , 0) ;  
                          
            if(diffid.equals("0")) continue ; 

            ProcPara = id ; 
            ProcPara += flag + diffid ; 
            RecordSet.executeProc("HrmSalaryScheduleAdd_Insert" , ProcPara) ;    
        }
    }

    else if(itemtype.equals("7")){
        RecordSet.executeProc("HrmArrangeShift_SelectAll" , "0") ; 	
	    while(RecordSet.next()){ 
            String shiftid = Util.null2String( RecordSet.getString("id") ) ; 
            String shiftpay = Util.null2String(request.getParameter("shift" + shiftid)) ;  
            if(Util.getDoubleValue(shiftpay,0) == 0 ) continue ; 
            ProcPara = id ; 
            ProcPara += flag + shiftid + flag + shiftpay  ; 
            RecordSet.executeProc("HrmSalaryShiftPay_Insert" , ProcPara) ;    
        }
        
        // 对一般工作时间
        String shiftpay = Util.null2String(request.getParameter("shift0")) ;  
        if(Util.getDoubleValue(shiftpay,0) != 0 ) {
            ProcPara = id ; 
            ProcPara += flag + "0" + flag + shiftpay  ; 
            RecordSet.executeProc("HrmSalaryShiftPay_Insert" , ProcPara) ; 
        }
    }
    else if(itemtype.equals("8")){
        RecordSet.executeSql(" select id from Hrmresource where status in (0,1,2,3) ") ; 	
	    while(RecordSet.next()){ 
            String resourceid = Util.null2String( RecordSet.getString("id") ) ; 
            String resourcepay = Util.null2String(request.getParameter("resource_" + resourceid)) ;  
            if(Util.getDoubleValue(resourcepay,0) == 0 ) continue ; 
            ProcPara = id ; 
            ProcPara += flag + resourceid + flag + resourcepay + flag + "0"   ; 
            RecordSet.executeProc("HrmSalaryResourcePay_Insert" , ProcPara) ;    
        }
    }
    else if(itemtype.equals("9") ) {
        String[] totalwels = Util.TokenizerString2( totalweld , "," ) ;
        for( int i=0 ; i < totalwel ; i++){//
            String objectid1 =Util.null2String(request.getParameter("objectidwel" + i));
            String scopetype = Util.null2String(request.getParameter("scopetypewel" + i)) ;
            //System.out.println("objectid"+objectid1);
            if( scopetype.equals(""))
                continue ;
            String objectid="";
            if(scopetype.equals("1"))
            objectid=objectid1;
            ProcPara =  id ;
            ProcPara += flag + scopetype ;
            RecordSet.executeProc("HrmSalaryCalBench_Insert",ProcPara);
            String benchid = "0" ;
             if(RecordSet.next()) benchid = Util.null2String(RecordSet.getString(1)) ;
                for(int j=0 ; j < Util.getIntValue(totalwels[i] , 0) ; j++){
                String timescope = "" + Util.getIntValue(request.getParameter("timescopewel" + i + "_" + j) , 0) ;
                String condition = "" + Util.null2String(request.getParameter("conwel" + i + "_" + j) ) ;
                String formula = "" + Util.null2String(request.getParameter("formulawel" + i + "_" + j) ) ;
                String conditiondsp = "" + Util.null2String(request.getParameter("condspwel" + i + "_" + j) ) ;
                String formuladsp = "" + Util.null2String(request.getParameter("formuladspwel" + i + "_" + j) ) ;


                if(formula.equals(""))
                    continue ;

                ProcPara =  benchid ;
                ProcPara += flag + timescope ;
                ProcPara += flag + condition ;
                ProcPara += flag + formula ;
                ProcPara += flag + conditiondsp ;
                ProcPara += flag + formuladsp ;
                RecordSet.executeProc("HrmSalaryCalrate_Insert" , ProcPara) ;
            }
           if(scopetype.equals("0")){
                //System.out.println("insert into HrmSalaryTaxscope(benchid,scopetype) values("+benchid+","+scopetype+")");
                RecordSet.executeSql("insert into HrmSalaryCalScope(itemid,benchid,objectid) values("+id+","+benchid+",-1)");
            }else{
            ArrayList l=Util.TokenizerString(objectid1,",");
            for(Iterator iter=l.iterator();iter.hasNext();){
                String theobjectid=(String)iter.next();
                //System.out.println("insert into HrmSalaryCalScope(itemid,benchid,objectid) values("+id+","+benchid+","+theobjectid+")");
                RecordSet.executeSql("insert into HrmSalaryCalScope(itemid,benchid,objectid) values("+id+","+benchid+","+theobjectid+")");
            }
            }
        }
    }
}


if (method.equals("delete")) {
    RecordSet.executeSql("select count(*) from hrmsalarypaydetail where itemid='"+id+"' or itemid like '"+id+"__'");
    int num=0;
    if(RecordSet.next()){
        num=RecordSet.getInt(1);
    }
    if(num>0){
        response.sendRedirect("HrmSalaryItemList.jsp?id="+id+"&subcompanyid="+subcompanyid+"&error=1") ;
        return;
    }else{
        RecordSet.executeProc("HrmSalaryItem_Delete" , id) ;
    }
}

if (method.equals("process")){
    SalaryManager.initItemSalary(id) ; 
}

if (!method.equals("process")) SalaryComInfo.removeSalaryCache() ; 

if (method.equals("add") || method.equals("edit") ) response.sendRedirect("HrmSalaryItemAdd.jsp?isclose=1&id="+id+"&subcompanyid="+subcompanyid) ;
else response.sendRedirect("HrmSalaryItemList.jsp?subcompanyid="+subcompanyid) ;
%>