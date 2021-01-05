<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="java.util.*" %>
<%@ page import="weaver.file.*" %>
<%@ page import="weaver.voting.bean.*"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />	
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page" />
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page" />
<jsp:useBean id="JobTitlesComInfo" class="weaver.hrm.job.JobTitlesComInfo"></jsp:useBean>		
<jsp:useBean id="ExcelFile" class="weaver.file.ExcelFile" scope="session"/>	
<%
String votingid = Util.null2String(request.getParameter("votingid"));

ExcelSheet es = new ExcelSheet() ;
ExcelRow er = es.newExcelRow () ;
	
er.addStringValue(SystemEnv.getHtmlLabelName(15486, user.getLanguage())) ;
er.addStringValue(SystemEnv.getHtmlLabelName(413, user.getLanguage())) ;
er.addStringValue(SystemEnv.getHtmlLabelName(18939, user.getLanguage())) ;
er.addStringValue(SystemEnv.getHtmlLabelName(141, user.getLanguage())) ;
er.addStringValue(SystemEnv.getHtmlLabelName(6086, user.getLanguage())) ;
er.addStringValue(SystemEnv.getHtmlLabelName(683, user.getLanguage())) ;

List rsclist = new ArrayList();
Map rscinfomap=new HashMap();
RecordSet.executeSql("select a.useranony,b.id,b.lastname,b.departmentid,b.subcompanyid1,b.jobtitle,b.seclevel from VotingRemark a inner join HrmResource b on a.resourceid=b.id where a.votingid="+votingid+" and b.status in(0,1,2,3) order by a.operatedate asc,a.operatetime asc");
while(RecordSet.next()){
	String tmpt_resourceid=Util.null2String(RecordSet.getString("id"));
	rsclist.add(tmpt_resourceid);
	List tmptRscInfoList=new ArrayList();
	tmptRscInfoList.add(Util.null2String(RecordSet.getString("useranony")));
	tmptRscInfoList.add(Util.null2String(RecordSet.getString("lastname")));
	tmptRscInfoList.add(Util.null2String(RecordSet.getString("departmentid")));
	tmptRscInfoList.add(Util.null2String(RecordSet.getString("subcompanyid1")));
	tmptRscInfoList.add(Util.null2String(RecordSet.getString("jobtitle")));
	tmptRscInfoList.add(Util.null2String(RecordSet.getString("seclevel")));
	rscinfomap.put(tmpt_resourceid,tmptRscInfoList);
}

Map selectdata=new HashMap();
RecordSet.executeSql("select * from VotingResource where votingid="+votingid);
while(RecordSet.next()){
	String tmpt_resourceid=Util.null2String(RecordSet.getString("resourceid"));
	String tmpt_questionid=Util.null2String(RecordSet.getString("questionid"));
	String tmpt_optionid=Util.null2String(RecordSet.getString("optionid"));
	
	if(selectdata.containsKey(tmpt_resourceid+"_"+tmpt_questionid)){
		List tmptlist=(List)selectdata.get(tmpt_resourceid+"_"+tmpt_questionid);
		tmptlist.add(tmpt_optionid);
	} else {
		List tmptlist=new ArrayList();
		tmptlist.add(tmpt_optionid);
		selectdata.put(tmpt_resourceid+"_"+tmpt_questionid,tmptlist);
	}
	
}

Map otherdata=new HashMap();
RecordSet.executeSql("select * from VotingResourceRemark where votingid="+votingid);
while(RecordSet.next()){
	String tmpt_resourceid=Util.null2String(RecordSet.getString("resourceid"));
	String tmpt_questionid=Util.null2String(RecordSet.getString("questionid"));
	String tmpt_otherinput=Util.null2String(RecordSet.getString("otherinput"));
	otherdata.put(tmpt_resourceid+"_"+tmpt_questionid,tmpt_otherinput);
}

Map optionmap=new HashMap();
RecordSet.executeSql("select * from VotingOption where votingid="+votingid);
while(RecordSet.next()){
	optionmap.put(RecordSet.getString("id"),RecordSet.getString("description"));
}

List qstList=new ArrayList();
Map qstTypeMap = new HashMap();
Map subQstMap = new HashMap();
RecordSet.executeSql("select * from VotingQuestion where questiontype in(0,1,3) and votingid="+votingid+" and exists(select 1 from votingoption where questionid=VotingQuestion.id) order by  pagenum asc ,showorder asc  ");
while(RecordSet.next()){
	String tmpt_qst_id=Util.null2String(RecordSet.getString("id"));
	String tmpt_qst_subject=Util.null2String(RecordSet.getString("subject"));
	int tmpt_qst_type=Util.getIntValue(RecordSet.getString("questiontype"));
	
	qstList.add(tmpt_qst_id);
	qstTypeMap.put(tmpt_qst_id,String.valueOf(tmpt_qst_type));
	
	List subQstList=new ArrayList();
	subQstMap.put(tmpt_qst_id,subQstList);
	if(tmpt_qst_type==1){
		int tmpt_count=0;
		rs.executeSql("select * from VotingOption where questionid="+tmpt_qst_id+" and roworcolumn=0 order by showorder asc");
		while(rs.next()){
			String tmpt_opt_id=Util.null2String(rs.getString("id"));
			subQstList.add(tmpt_opt_id);
			String tmpt_opt_subject=Util.null2String(rs.getString("description"));
			
			if(tmpt_count==0){
				tmpt_opt_subject=SystemEnv.getHtmlLabelName(126294, user.getLanguage())+tmpt_qst_subject+SystemEnv.getHtmlLabelName(126295, user.getLanguage())+tmpt_opt_subject;
				tmpt_count++;
			}
			
			er.addStringValue(tmpt_opt_subject) ;
		}
		continue;
	}
	er.addStringValue(tmpt_qst_subject) ;
}
es.addExcelRow(er) ;

for(int i=0;i<rsclist.size();i++){
	er = es.newExcelRow();
	
	String tmpt_resourceid=(String)rsclist.get(i);
	List tmptRscInfoList=(List)rscinfomap.get(tmpt_resourceid);
	
	String tmpt_useranony=(String)tmptRscInfoList.get(0);
	String tmpt_lastname="";
	String tmpt_dptmname="";
	String tmpt_subcompanyname="";
	String tmpt_jobtitle="";
	String tmpt_seclevel="";
	
	if(!"1".equals(tmpt_useranony)){
		tmpt_lastname=(String)tmptRscInfoList.get(1);
		tmpt_dptmname=DepartmentComInfo.getDepartmentname((String)tmptRscInfoList.get(2));
		tmpt_subcompanyname=SubCompanyComInfo.getSubCompanyname((String)tmptRscInfoList.get(3));
		tmpt_jobtitle=JobTitlesComInfo.getJobTitlesname((String)tmptRscInfoList.get(4));
		tmpt_seclevel=(String)tmptRscInfoList.get(5); 
	}
	
	er.addStringValue(String.valueOf(i+1)) ;
	er.addStringValue(tmpt_lastname);
	er.addStringValue(tmpt_dptmname);
	er.addStringValue(tmpt_subcompanyname);
	er.addStringValue(tmpt_jobtitle);
	er.addStringValue(tmpt_seclevel);
	
	for(int j=0;j<qstList.size();j++){
		String tmpt_qst_id=(String)qstList.get(j);
		String tmpt_qst_type=(String)qstTypeMap.get(tmpt_qst_id);
		
		if("3".equals(tmpt_qst_type)){
			er.addStringValue(Util.null2String(otherdata.get(tmpt_resourceid+"_"+tmpt_qst_id)));
		} else if("0".equals(tmpt_qst_type)){
			String tmptcellstr="";
			
			List tmptselectlist=(List)selectdata.get(tmpt_resourceid+"_"+tmpt_qst_id);
			if(tmptselectlist!=null){
				for(int k=0;k<tmptselectlist.size();k++){
					String tmpt_option_id=(String)tmptselectlist.get(k);
					if(optionmap.containsKey(tmpt_option_id)){
						String tmpt_option_desc=(String)optionmap.get(tmpt_option_id);
						tmptcellstr +=tmpt_option_desc+";";
					}
				}	
			}
			if(otherdata.containsKey(tmpt_resourceid+"_"+tmpt_qst_id)){
				String tmpt_a=Util.null2String(otherdata.get(tmpt_resourceid+"_"+tmpt_qst_id));
				if(!"".equals(tmpt_a)){
					tmptcellstr +="["+SystemEnv.getHtmlLabelName(811, user.getLanguage())+"]"+tmpt_a+";";
				}
			}
			er.addStringValue(tmptcellstr);
		} else if("1".equals(tmpt_qst_type)){
			List tmptselectlist=(List)selectdata.get(tmpt_resourceid+"_"+tmpt_qst_id);
			List subQstList=(List)subQstMap.get(tmpt_qst_id);
			
			if(subQstList==null) continue;
			
			for(int m=0;m<subQstList.size();m++){
				String tmptcellstr="";
				String tmpt_subqst_id=(String)subQstList.get(m);
				
				if(tmptselectlist!=null){
					for(int n=0;n<tmptselectlist.size();n++){
						String tmpt_option_id=(String)tmptselectlist.get(n);
						int tmptindex=tmpt_option_id.indexOf("_");
						if(tmpt_option_id.startsWith(tmpt_subqst_id+"_")){
							String tmpt_suboption_id=tmpt_option_id.substring(tmptindex+1);
							String tmpt_suboption_desc=(String)optionmap.get(tmpt_suboption_id);
							tmptcellstr +=tmpt_suboption_desc+";";
						}
					}
				}	
				
				er.addStringValue(tmptcellstr);
			}
			
		} 
		
	}
}

String excelfile="ExcelFile_"+votingid+"_"+user.getUID();

ExcelFile.init() ;
ExcelFile.setFilename(SystemEnv.getHtmlLabelName(20042, user.getLanguage())) ;
ExcelFile.addSheet(SystemEnv.getHtmlLabelName(20042, user.getLanguage()), es) ;
session.setAttribute(excelfile,ExcelFile);

response.sendRedirect("/weaver/weaver.file.ExcelOut?excelfile="+excelfile);

%>