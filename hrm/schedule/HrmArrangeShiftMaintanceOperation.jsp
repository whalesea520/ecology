<%@ page import = "weaver.general.Util" %>
<%@ page import = "java.util.*" %>
<jsp:useBean id = "RecordSet" class = "weaver.conn.RecordSet" scope = "page"/>
<%@page import="weaver.hrm.company.DepartmentComInfo"%>
<%@page import="weaver.hrm.company.SubCompanyComInfo"%>

<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file = "/systeminfo/init_wev8.jsp"%>
<%!
public ArrayList<String> getLsResource(weaver.conn.RecordSet rs,String sqlwhere2)throws Exception{
	ArrayList<String> lsReource = new ArrayList<String>();
	ArrayList<HrmShareType>  lsHrmShareType = new ArrayList<HrmShareType>();
	HrmShareType hrmShareType = new HrmShareType();
	
	//首先获得范围表中的数据
	rs.executeSql(" SELECT sharetype,relatedId,level_from, level_to FROM hrmarrangeshiftset ");
	while(rs.next()){
		hrmShareType = new HrmShareType();
		hrmShareType.setSharetype(rs.getInt("sharetype"));
		hrmShareType.setRelatedId(rs.getInt("relatedId"));
		hrmShareType.setLevel_from(rs.getInt("level_from"));
		hrmShareType.setLevel_to(rs.getInt("level_to"));
		lsHrmShareType.add(hrmShareType);
	}
	
	for(int i=0;i<lsHrmShareType.size();i++){
		hrmShareType = lsHrmShareType.get(i);
		if(hrmShareType.getSharetype()==5){
			//所有人
			rs.executeSql("select id from hrmresource where  status in(0,1,2,3) " 
										+" and seclevel >= "+hrmShareType.getLevel_from() +" and seclevel >= "+hrmShareType.getLevel_to()
										+ sqlwhere2 + " order by departmentid ");
			while(rs.next()){
				lsReource.add(rs.getString("id"));
			}
		}else if(hrmShareType.getSharetype()==4){
			//角色
			rs.executeSql("SELECT resourceid FROM HrmRoleMembers WHERE roleid ="+hrmShareType.getRelatedId()
									+" and rolelevel>="+hrmShareType.getLevel_from() +" AND rolelevel<="+hrmShareType.getLevel_to());
			while(rs.next()){
				lsReource.add(rs.getString("id"));
			}
		}else if(hrmShareType.getSharetype()==3){
			//人力资源	
			lsReource.add(hrmShareType.getRelatedId()+"");
		}else if(hrmShareType.getSharetype()==2){
			//部门
			rs.executeSql("SELECT id FROM hrmresource WHERE departmentid in ("+DepartmentComInfo.getAllChildDepartId(""+hrmShareType.getRelatedId(),""+hrmShareType.getRelatedId())
								+") and seclevel>="+hrmShareType.getLevel_from() +" AND seclevel<="+hrmShareType.getLevel_to()+ sqlwhere2 + " order by departmentid");
			while(rs.next()){
			lsReource.add(rs.getString("id"));
			}
		}else if(hrmShareType.getSharetype()==1){
			//分部
			String subComIds = SubCompanyComInfo.getSubCompanyTreeStr(""+hrmShareType.getRelatedId())+hrmShareType.getRelatedId();
			rs.executeSql("SELECT id FROM hrmresource WHERE subcompanyid1 in ("+subComIds
								+") and seclevel>="+hrmShareType.getLevel_from() +" AND seclevel<="+hrmShareType.getLevel_to()+ sqlwhere2 + " order by departmentid");
			while(rs.next()){
				lsReource.add(rs.getString("id"));
			}
		}
	}
	return lsReource;
}

%>
<%
String operation = Util.null2String(request.getParameter("operation"));
String subcompanyid = Util.fromScreen(request.getParameter("subcompanyid") , user.getLanguage()) ; //分部
String departmentid = Util.fromScreen(request.getParameter("departmentid") , user.getLanguage()) ; //部门
String fromdate = Util.fromScreen(request.getParameter("fromdate") , user.getLanguage()) ; //排班日期从
String enddate = Util.fromScreen(request.getParameter("enddate") , user.getLanguage()) ; //排班日期到

char separator = Util.getSeparator() ;
String procedurepara="" ; 

Calendar thedate = Calendar.getInstance() ; //

String currentdate =  Util.add0(thedate.get(Calendar.YEAR) , 4) + "-" + 
                Util.add0(thedate.get(Calendar.MONTH) + 1 , 2) + "-" + 
                Util.add0(thedate.get(Calendar.DAY_OF_MONTH) , 2) ;   // 当天

if(operation.equals("save")) {
    String selectdates[] = request.getParameterValues("selectdate") ;
    String selectresources[] = request.getParameterValues("selectresource") ;

    if( selectdates != null && selectresources != null ) {

        String selectresourcestrs = "" ;
        String selectdatestrs = "" ;

        for(int i = 0 ; i < selectresources.length ; i++) {
            String resourceid = selectresources[i] ; 
            if( resourceid == null ) continue ;
            if( selectresourcestrs.equals("") ) selectresourcestrs = resourceid ;
            else selectresourcestrs += "," + resourceid ;
        }
            
        for(int j = 0 ; j < selectdates.length ; j++) {
            String thetempdate = selectdates[j] ;
            if( thetempdate == null || Util.dayDiff(currentdate,thetempdate) < -2 ) continue ; // 排班日期小于等于当天的不处理
            if( selectdatestrs.equals("") ) selectdatestrs = "'"+thetempdate+"'" ;
            else selectdatestrs += ",'" + thetempdate+"'" ;
        }
        
        if( !selectresourcestrs.equals("") &&  !selectdatestrs.equals("") ) {
            RecordSet.executeSql("delete HrmArrangeShiftInfo where resourceid in (" + selectresourcestrs + ") and shiftdate in (" + selectdatestrs + ")") ; 
        }
    
        for(int i = 0 ; i < selectresources.length ; i++) {
            String resourceid = selectresources[i] ; 

            if( resourceid == null ) continue ;
            
            for(int j = 0 ; j < selectdates.length ; j++) {
                String thetempdate = selectdates[j] ;
            
                if( thetempdate == null || currentdate.compareTo(thetempdate) > 1 ) continue ; // 排班日期小于等于当天的前一天的不处理 
                
                String shiftidstr = request.getParameter(resourceid+"_"+thetempdate);

                String shiftids[] = Util.TokenizerString2(shiftidstr,",");

                if(shiftids == null) continue ; 

                for( int k=0 ; k < shiftids.length ; k++ ) {

                    String shiftid = Util.null2String( shiftids[k] ) ;
                    if( !shiftid.equals("") ) {
                        procedurepara = resourceid + separator + thetempdate + separator +  shiftid ; 
                        RecordSet.executeProc("HrmArrangeShiftInfo_Insert" , procedurepara) ; 
                    }
                }
            } 
        } 
    }
}else if(operation.equals("process")) {
    String resourceid = Util.fromScreen(request.getParameter("multresourceid") , user.getLanguage()) ; 
    String shiftid = Util.null2String(request.getParameter("shiftname")) ;
    String sqlwhere1="";
    if(shiftid.equals("")) { 
        sqlwhere1 += " and shiftdate >='" + fromdate + "'" ; 
        sqlwhere1 += " and shiftdate <='" + enddate + "'" ; 

        String sql = " delete from HrmArrangeShiftInfo where resourceid in ( "+ resourceid + " ) " + sqlwhere1 ;
        out.print(sql) ;
        RecordSet.executeSql(sql) ; 
    }else {
        ArrayList selectdates = new ArrayList() ; 

        int fromyear = Util.getIntValue(fromdate.substring(0 , 4)) ; 
        int frommonth = Util.getIntValue(fromdate.substring(5 , 7)) ; 
        int fromday = Util.getIntValue(fromdate.substring(8 , 10)) ; 
        String tempdate = fromdate ; 

        thedate.set(fromyear,frommonth - 1 , fromday) ; 

        while( tempdate.compareTo(enddate) <= 0 ) {
            selectdates.add(tempdate) ; 

            thedate.add(Calendar.DATE , 1) ; 
            tempdate =  Util.add0(thedate.get(Calendar.YEAR) , 4) + "-" + 
                        Util.add0(thedate.get(Calendar.MONTH) + 1 , 2) + "-" + 
                        Util.add0(thedate.get(Calendar.DAY_OF_MONTH) , 2) ; 
        }

        // 得到按照排班来管理的所有人员
        ArrayList<String> reesourceshifts = getLsResource(RecordSet,"");
        ArrayList<String> resourceids = Util.TokenizerString(resourceid,",");
        for(int i = 0 ; i < resourceids.size() ; i++) {
        		String resourceid1 = resourceids.get(i) ;
            if( resourceid1 ==null || reesourceshifts.indexOf(resourceid1) == -1 ) continue ; 
            for(int j = 0 ; j < selectdates.size() ; j++) {
                String thetempdate = (String)selectdates.get(j) ;
                if( thetempdate == null ) continue ;
                String[] shiftids = shiftid.split(",");
                for( int k=0 ; k < shiftids.length ; k++ ) {

                  String tmp_shiftid = Util.null2String( shiftids[k] ) ;
                  if( !tmp_shiftid.equals("") ) {
                    procedurepara = resourceid1 + separator + thetempdate + separator +  tmp_shiftid ; 
                    RecordSet.executeProc("HrmArrangeShiftInfo_Save" , procedurepara) ; 
                  }
              }
            }
        } 
    }
    response.sendRedirect("HrmArrangeShiftProcess.jsp?isclose=1") ;
    return;
 }
 
 response.sendRedirect("HrmArrangeShiftMaintance.jsp?subcompanyid="+subcompanyid+"&departmentid="+departmentid+"&fromdate="+fromdate+"&enddate="+enddate) ; 
%>