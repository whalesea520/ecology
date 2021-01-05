<%@ page import="weaver.general.Util,weaver.file.*,java.util.*" %>
<%@ page import="weaver.soa.hrm.HrmService"%>
<%@ page import="weaver.soa.hrm.ExportResult"%>
<%@ page import="weaver.hrm.company.DepartmentComInfo"%>
<%@ page import="weaver.hrm.job.JobTitlesComInfo"%>
<%@ page import="weaver.hrm.resource.ResourceComInfo"%>
<%@ page import="weaver.hrm.location.LocationComInfo"%>

<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="ExcelParse" class="weaver.file.ExcelParse" scope="page" />
<jsp:useBean id="FileManage" class="weaver.file.FileManage" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSet2" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page" />
<jsp:useBean id="departmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page" />
<jsp:useBean id="JobTitlesComInfo" class="weaver.hrm.job.JobTitlesComInfo" scope="page" />
<%!
private weaver.conn.RecordSet rst=new weaver.conn.RecordSet();
private List incorrectList=new ArrayList();//保存导入不符合要求的数据
private Map errMsgMap=new HashMap();//存储记录导入失败的原因
private void addIncorrectName(String name,String errMsg){
	ExportResult exp=new ExportResult();
	exp.setLastname(name);
	exp.setOperation("82");//新建
	exp.setStatus("498");//失败
	errMsgMap.put(name,errMsg);
	this.incorrectList.add(exp);
}

private boolean isExistSubcompany(int subCompanyId,String subCompanyName){//如果不加id无法确定分部和部门之间的上下级关系
	String sql="SELECT * FROM HrmSubcompany WHERE id="+subCompanyId+" AND (subcompanyName='"+subCompanyName+"' OR subcompanydesc='"+subCompanyName+"')";
	rst.executeSql(sql);
	//System.out.println("isExistSubcompany:"+sql);
	return rst.next()?true:false;
}

/** 根据部门名称获取部门Id，如果不存在返回-1 */
//private List[] getDepartmentId(String depName){
	//return getDepartmentId(depName, "");
//}

private List[] getDepartmentId(String depName, String departid){
	departid = Util.null2String(departid);
	String sql="select id,subcompanyid1 from HrmDepartment where departmentmark='"+depName+"' OR departmentname='"+depName+"'";
	rst.executeSql(sql);
	//System.out.println("getDepartmentId:"+sql);
	List[] arList=null;
	if(rst.next()){
		arList=new ArrayList[2];
		arList[0]=new ArrayList();
		arList[1]=new ArrayList();
		do{
			String id_tmp = rst.getString("id");
			if(!"".equals(departid) && !id_tmp.equals(departid)){
				continue;
			}
			arList[0].add(rst.getString("id"));
			arList[1].add(rst.getString("subcompanyid1"));
		}while(rst.next());
	}
	return arList;	
}

/** 根据岗位名称获取岗位Id，如果不存在则返回-1 */
private int getJobTitleId(String jobTitleName,int depId){
	String string=this.getSubDepString(String.valueOf(depId))+"0";
	String sql="select id from HrmJobTitles where jobDepartmentId IN ("+depId+") AND (jobtitlemark='"+jobTitleName+"' OR jobtitlename='"+jobTitleName+"')";
	rst.executeSql(sql);
	//System.out.println("getJobTitleId:"+sql);
	return rst.next()?rst.getInt(1):-1;
}
private Map subDeps=null;
private String getSubDepString(String depId){
	String subDepString=depId+",";
	if(subDeps.containsKey(depId)){
		List list1=(List)subDeps.get(depId);
		for(int i=0;i<list1.size();i++){
			String obj=list1.get(i).toString();
			if(!subDeps.containsKey(depId)){
				subDepString+=obj+",";
				continue;
			}else subDepString+=this.getSubDepString(obj);//递归求出所有下级
		}
	}
	return subDepString;
}

private Map initSubDep(DepartmentComInfo dep){

	DepartmentComInfo deptcominfo=dep;
	Map subDep=new HashMap();
	String depId=null;
	String supDepId=null;
	List list1=null;
	while(deptcominfo.next()){
		String dept=deptcominfo.getDepartmentname();
		String deptmark=deptcominfo.getDepartmentmark();		
		depId=deptcominfo.getDepartmentid();
		supDepId=deptcominfo.getDepartmentsupdepid(depId);
		supDepId=supDepId.equalsIgnoreCase("")?"0":supDepId;
		if(supDepId.equalsIgnoreCase("0"))continue;
		if(!subDep.containsKey(supDepId)){
			list1=new ArrayList();
			subDep.put(supDepId,list1);
		}else list1=(List)subDep.get(supDepId);
		list1.add(depId);
	}
	return subDep;
}
%>
<%

FileUploadToPath fu = new FileUploadToPath(request) ;    // 非压缩上传
String filename = fu.uploadFiles("excelfile") ;

HrmService service = new HrmService();
service.setExp_result(new ArrayList());

errMsgMap.clear();
incorrectList.clear();
this.subDeps=this.initSubDep(departmentComInfo);//初始化求出所有下级映射关系

if(!filename.equals("")) {

    // 找出对应用户列表存入缓存


    ExcelParse.init( filename ) ;
    int recordercount = 0 ;
    while( true ) {
        recordercount ++ ;
        String workcode = Util.null2String( ExcelParse.getValue("1", ""+recordercount , "1" ) ).trim() ;
        String lastname = Util.null2String( ExcelParse.getValue("1", ""+recordercount , "2" ) ).trim() ;
        String sex = Util.null2String( ExcelParse.getValue("1", ""+recordercount , "3" ) ).trim() ;
        String departid = Util.null2String( ExcelParse.getValue("1", ""+recordercount , "4" ) ).trim() ;
        String department = Util.null2String( ExcelParse.getValue("1", ""+recordercount , "5" ) ).trim() ;
        String subcompany = Util.null2String( ExcelParse.getValue("1", ""+recordercount , "6" ) ).trim() ;
        String jobtitle = Util.null2String( ExcelParse.getValue("1", ""+recordercount , "7" ) ).trim() ;
        String manager = Util.null2String( ExcelParse.getValue("1", ""+recordercount , "8" ) ).trim() ;
        String status = Util.null2String( ExcelParse.getValue("1", ""+recordercount , "9" ) ).trim() ;
        String location = Util.null2String( ExcelParse.getValue("1", ""+recordercount , "10" ) ).trim() ;
        String loginid = Util.null2String( ExcelParse.getValue("1", ""+recordercount , "11" ) ).trim() ;
        String password = Util.null2String( ExcelParse.getValue("1", ""+recordercount , "12" ) ).trim() ;
        String seclevel = Util.null2String( ExcelParse.getValue("1", ""+recordercount , "13" ) ).trim() ;
        //标题行
        if( recordercount == 1 ) continue ;

        if( lastname.equals("") ) break ;
		
		List[] ids=this.getDepartmentId(department,departid);
		int errNum=-21159;//默认为部门不存在
		int depId=0;
		int jobTitleId=0;
		int subCompanyId=0;
		boolean isfalsh = true;
		String islawful = "select count(id) from HrmDepartment where departmentmark='"+department+"' OR departmentname='"+department+"'";
		RecordSet2.executeSql(islawful);
		if(RecordSet2.next()){
			if(RecordSet2.getInt(1)>1 && "".equals(departid)){
				errNum=-22258;
				isfalsh = false;
			}
        }
		
		if(ids!=null && isfalsh){//
			List list1=ids[0];
			List list2=ids[1];
			for(int i=0;i<list1.size();i++){
				errNum=-21159;//默认为部门不存在
				depId=Integer.parseInt(list1.get(i).toString());
				subCompanyId=Integer.parseInt(list2.get(i).toString());
				jobTitleId=this.getJobTitleId(jobtitle,depId);
				if(jobTitleId>0){
					if(isExistSubcompany(subCompanyId,subcompany)){
						errNum=0;break;//如果存在则直接跳出循环
					}else errNum=-21161;
				}else errNum=-21160;
			}
		}
		if(errNum<0){
			String errMsg=SystemEnv.getHtmlLabelName(-errNum,user.getLanguage());
			if(errNum==-21161)errMsg+=SystemEnv.getHtmlLabelName(21168,user.getLanguage());
			this.addIncorrectName(lastname,errMsg);//添加不存在列表
			continue;
		}
        // add user
        weaver.soa.hrm.User u=new weaver.soa.hrm.User();
        if(!workcode.equals("")) {
              u.setWorkcode(workcode);           
        }
        u.setLastname(lastname);
        if(!sex.equals(""))
        u.setSex(sex);
		u.setDepartmentid(depId);
/*        DepartmentComInfo deptcominfo=new DepartmentComInfo();
        if(!department.equals("")){
        while(deptcominfo.next()) {
            String dept=deptcominfo.getDepartmentname();
            String deptmark=deptcominfo.getDepartmentmark();
            if(!subcompany.equals("")){
                String subname=SubCompanyComInfo.getSubCompanyname(deptcominfo.getSubcompanyid1());
                String subdesc=SubCompanyComInfo.getSubCompanydesc(deptcominfo.getSubcompanyid1());
                if(!subname.equals(subcompany)&&!subdesc.equals(subcompany))continue;
            }
            if(dept.equals(department)||deptmark.equals(department)) {
              u.setDepartmentid(Integer.parseInt(deptcominfo.getDepartmentid()));
            }
        }
        }
*/
		u.setJobtitle(jobTitleId);
/*       if(!jobtitle.equals("")){
        JobTitlesComInfo jtcominfo=new JobTitlesComInfo();
        while(jtcominfo.next()) {
            String deptid=jtcominfo.getDepartmentid();
            if(deptcominfo.getDepartmentname(deptid).equals(department)){
                String companyid=deptcominfo.getSubcompanyid1(deptid);
                if(SubCompanyComInfo.getSubCompanyname(companyid).equals(subcompany)){
                    String jt=jtcominfo.getJobTitlesname();
                    String jtmark=jtcominfo.getJobTitlesmark();
                    if(jt.equals(jobtitle)||jtmark.equals(jobtitle)) {
                        u.setJobtitle(Integer.parseInt(jtcominfo.getJobTitlesid()));
                    }
                }
            }            
        }
        }*/

        if (!manager.equals("")) {
		    String mg_name = "";
		    String hrm_workcode = "";
		    int checkmanager = manager.indexOf("/");
		    if(checkmanager > 0){
		      mg_name = manager.substring(0,manager.lastIndexOf("/"));
		      hrm_workcode = manager.substring(manager.lastIndexOf("/")+1,manager.length());
		      RecordSet.executeSql("select id from hrmresource where lastname = '"+mg_name+"' and workcode = '"+hrm_workcode+"'");
			  if(RecordSet.next()){
			     u.setManagerid(RecordSet.getInt("id"));				     
			  }	
		    }else{
		        ResourceComInfo rscominfo = new ResourceComInfo();
		        while(rscominfo.next()) {
		            String name = rscominfo.getLastname();
		            if(name.equals(manager)) {
		              u.setManagerid(Integer.parseInt(rscominfo.getResourceid()));
		              break;
		            }
		        }
		    }			    			
		}

      if(!status.equals("")){
          if(status.equals(SystemEnv.getHtmlLabelName(15710,user.getLanguage()))){
             u.setStatus(0);
          }
          if(status.equals(SystemEnv.getHtmlLabelName(15711,user.getLanguage()))){
             u.setStatus(1);
          }
          if(status.equals(SystemEnv.getHtmlLabelName(480,user.getLanguage()))){
             u.setStatus(2);
          }
          if(status.equals(SystemEnv.getHtmlLabelName(15844,user.getLanguage()))){
             u.setStatus(3);
          }
          if(status.equals(SystemEnv.getHtmlLabelName(6094,user.getLanguage()))){
             u.setStatus(4);
          }
          if(status.equals(SystemEnv.getHtmlLabelName(6091,user.getLanguage()))){
             u.setStatus(5);
          }
          if(status.equals(SystemEnv.getHtmlLabelName(6092,user.getLanguage()))){
             u.setStatus(6);
          }
          if(status.equals(SystemEnv.getHtmlLabelName(2245,user.getLanguage()))){
             u.setStatus(7);
          }
          if(status.equals(SystemEnv.getHtmlLabelName(1831,user.getLanguage()))){
             u.setStatus(10);
          }
        }

        if(!location.equals("")){
        LocationComInfo locationcominfo=new LocationComInfo();
        while(locationcominfo.next()) {
            String name=locationcominfo.getLocationname();
            if(name.equals(location)) {
             u.setLocationid(Integer.parseInt(locationcominfo.getLocationid()));

            }
        }
        }
        //modify by ds 人员导入可以导入登陆账号为空的人员
		/*
        if(!loginid.equals("")){
              u.setLoginid(loginid);
        }
        */
        u.setLoginid(loginid);
        if(!password.equals("")){
              u.setPassword(password);
        }
        if(!seclevel.equals("")){
        try{
        u.setSeclevel((int) Double.parseDouble(seclevel));
        }catch(Exception e){

        }
    }

       service.addUser(u);
        }
    FileManage.DeleteFile( filename ) ;
}


%>
     
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
</head>
<%
    String imagefilename = "/images/hdMaintenance_wev8.gif";
    String titlename = SystemEnv.getHtmlLabelName(17887,user.getLanguage());
    String needfav ="1";
    String needhelp ="";
%>
    <BODY>
    <%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
    <%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>

    <%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

    <table width=100% height=100% border="0" cellspacing="0" cellpadding="0">
    <colgroup>
    <col width="10">
    <col width="">
    <col width="10">
    <tr>
    <td height="10" colspan="3"></td>
    </tr>
    <tr>
    <td ></td>
    <td valign="top">
    <TABLE class=Shadow>
    <tr>
    <td valign="top">
    <TABLE class=ListStyle cellspacing=1 >
      <COLGROUP>
      <COL width="20%">
      <COL width="20">
      <COL width="20">
	  <COL width="40">
      <TBODY>
      <TR class=Header>
        <TH colSpan=4><%=SystemEnv.getHtmlLabelName(17887,user.getLanguage())+SystemEnv.getHtmlLabelName(320,user.getLanguage())%></TH></TR>
        <TR class=Header>
        <TD><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></TD>
        <TD><%=SystemEnv.getHtmlLabelName(104,user.getLanguage())%></TD>
        <TD><%=SystemEnv.getHtmlLabelName(602,user.getLanguage())%></TD>
		<TD><%=SystemEnv.getHtmlLabelName(22259,user.getLanguage())%></TD>
      </TR>
      <TR class=Line><TD colspan="3" ></TD></TR>
<%
        List list=service.getExp_result();
		list.addAll(incorrectList);
        ExportResult[] result=(ExportResult[]) list.toArray(new ExportResult[list.size() ]);
         int needchange = 0;
          for(int i=0;i<result.length;i++){
          int isfirst = 1;
           try{
               if(needchange ==0){
                   needchange = 1;
 %>
      <TR class=datalight>
 <%
          }else{
              needchange=0;
 %>
         <TR class=datadark>
 <%
       }
	   String styleInfo=(result[i].getStatus()=="498")?" style=\"color:red\"":"";
 %>
        <TD> <%=result[i].getLastname()%>
        </TD>
        <TD><%=SystemEnv.getHtmlLabelName(Util.getIntValue(result[i].getOperation()),user.getLanguage())%>
        </TD>
        <%if(result[i].getStatus()=="15242"){%>
        <TD<%=styleInfo%>><%
			out.print(SystemEnv.getHtmlLabelName(Util.getIntValue(result[i].getStatus()),user.getLanguage()));
		%>
        </TD><%}else{%>
        <TD<%=styleInfo%>><%
			out.print(SystemEnv.getHtmlLabelName(Util.getIntValue(result[i].getStatus()),user.getLanguage()));
			Object obj=errMsgMap.get(result[i].getLastname());
			if(obj!=null)out.print("("+obj.toString()+")");
		%>
        </TD><%}%>
		<TD> 
		<%if(result[i].getStatus()=="15242") {%>
				<%=departmentComInfo.getDepartmentname(""+result[i].getDepartment())%>/<%=JobTitlesComInfo.getJobTitlesname(""+result[i].getJobtitle())%>
		<%}%>
        </TD>
      </TR>
<%isfirst=0;
          }catch(Exception e){
            System.out.println(e.toString());
          }

        }
%>
     </TBODY></TABLE>
    </td>
    </tr>
    </TABLE>
    </td>
    <td></td>
    </tr>
    <tr>
    <td height="10" colspan="3"></td>
    </tr>
    </table>


    </BODY></HTML>
