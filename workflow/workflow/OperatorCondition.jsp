
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ page import="weaver.conn.*" %>
 <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="UrlComInfo" class="weaver.workflow.field.UrlComInfo" scope="page" />

<HTML><HEAD>
<LINK REL=stylesheet type=text/css HREF=/css/Browser_wev8.css>
<LINK REL=stylesheet type=text/css HREF=/css/Weaver_wev8.css>
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
<script Language="JavaScript">
//***********默认设置定义.*********************
var tPopWait=50;//停留tWait豪秒后显示提示。
var tPopShow=5000;//显示tShow豪秒后关闭提示
var showPopStep=20;
var popOpacity=99;
//***************内部变量定义*****************
var sPop=null;
var curShow=null;
var tFadeOut=null;
var tFadeIn=null;
var tFadeWaiting=null;
document.write("<style   type='text/css' id='defaultPopStyle'>");
document.write(".cPopText   { background-color: #F8F8F5;color:#000000; border:1px #000000 solid;font-color: font-size:12px;   padding-right:   4px;   padding-left:   4px;   height:   20px;   padding-top:   2px;   padding-bottom:   2px;   filter:   Alpha(Opacity=0)}");
document.write("</style>");
document.write("<iframe id = 'dypopLayerFrm' style=\"position:absolute;z-index:9;width:expression(this.nextSibling.offsetWidth);height:expression(this.nextSibling.offsetHeight);top:expression(this.nextSibling.offsetTop);left:expression(this.nextSibling.offsetLeft);\" frameborder=\"0\"></iframe><div id='dypopLayer' style='position:absolute;z-index:1000;display:none;' class='cPopText'></div>");

function showtitle(s,e) {

}
</script>    
</HEAD>
<%

int conid = Util.getIntValue(request.getParameter("id"),0);
String isbill = Util.null2String(request.getParameter("isbill"));
String wfid = Util.null2String(request.getParameter("wfid"));//zzl
String haspost = Util.null2String(request.getParameter("haspost"));
String isclear = Util.null2String(request.getParameter("isclear"));
String fromsrc=Util.null2String(request.getParameter("fromsrc"));
String tablename="workflow_form";
int formid = Util.getIntValue(request.getParameter("formid"),0);

//add by sean for TD3074
int fromBillManagement = Util.getIntValue(request.getParameter("fromBillManagement"),0);
int linkid = Util.getIntValue(request.getParameter("linkid"),0);

String[] checkcons = request.getParameterValues("check_con");

ArrayList ids = new ArrayList();
ArrayList colnames = new ArrayList();
ArrayList opts = new ArrayList();
ArrayList values = new ArrayList();
ArrayList names = new ArrayList();
ArrayList opt1s = new ArrayList();
ArrayList value1s = new ArrayList();
ids.clear();
colnames.clear();
opt1s.clear();
names.clear();
value1s.clear();
opts.clear();
values.clear();

String sqlwhere = "";
//add by xhheng @20050205 for TD 1537
String sqlwherecn="";

if(checkcons!=null){

    for(int i=0;i<checkcons.length;i++){
        String tmpid = ""+checkcons[i];
        String tmpcolname = ""+Util.null2String(request.getParameter("con"+checkcons[i]+"_colname"));
        String tmphtmltype = ""+Util.null2String(request.getParameter("con"+checkcons[i]+"_htmltype"));
        String tmptype = ""+Util.null2String(request.getParameter("con"+checkcons[i]+"_type"));
        String tmpopt = ""+Util.null2String(request.getParameter("con"+checkcons[i]+"_opt"));
        String tmpvalue = ""+Util.null2String(request.getParameter("con"+checkcons[i]+"_value"));
        String tmpname = ""+Util.null2String(request.getParameter("con"+checkcons[i]+"_name"));
        String tmpopt1 = ""+Util.null2String(request.getParameter("con"+checkcons[i]+"_opt1"));
        String tmpvalue1 = ""+Util.null2String(request.getParameter("con"+checkcons[i]+"_value1"));
        String tmpfeildid = ""+Util.null2String(request.getParameter("con"+checkcons[i]+"_fieldid"));
    //add by xhheng @20050205 for TD 1537
        String tmpcolnamecn = ""+Util.null2String(request.getParameter("con"+checkcons[i]+"_colname_cn"));
		//System.out.println("tmpid:"+tmpid+" tmpcolname:"+tmpcolname+" tmphtmltype:"+tmphtmltype+" tmptype:"+tmptype+" tmpopt:"+tmpopt+" tmpvalue:"+tmpvalue+" tmpname:"+tmpname+" tmpopt1:"+tmpopt1+" tmpvalue1:"+tmpvalue1+" tmpfeildid:"+tmpfeildid+" tmpcolnamecn:"+tmpcolnamecn);    
        ids.add(tmpid);
        colnames.add(tmpcolname);
        opts.add(tmpopt);
        values.add(tmpvalue);
        names.add(tmpname);
        opt1s.add(tmpopt1);
        value1s.add(tmpvalue1);
        //生成where子句
         if(isbill.equals("1"))
        {
        rs.executeSql("select tablename from workflow_bill where id = " + formid); // 查询工作流单据表的信息
            if (rs.next())
                tablename = rs.getString("tablename");          // 获得单据的主表
            
        }
        tmpcolname=tablename+"."+tmpcolname;
        if (tmpid.equals("0"))
        {
  
                sqlwhere += "and ( exists (select 1 from workflow_requestbase where requestid="+tablename+".requestid and creater ";
                if(tmpopt.equals("1"))  sqlwhere+=" in ("+tmpvalue+") ";
                if(tmpopt.equals("2"))  sqlwhere+=" not in ("+tmpvalue+") ";
                if (!tmpvalue.equals(""))
                sqlwhere+=")";
                sqlwherecn += SystemEnv.getHtmlLabelName(18760,user.getLanguage())+" ("+SystemEnv.getHtmlLabelName(882,user.getLanguage());
                if(tmpopt.equals("1"))  sqlwherecn+=SystemEnv.getHtmlLabelName(18805,user.getLanguage())+" ("+tmpname+") "+SystemEnv.getHtmlLabelName(19009,user.getLanguage());
                if(tmpopt.equals("2"))  sqlwherecn+=SystemEnv.getHtmlLabelName(19008,user.getLanguage())+" ("+tmpname+") "+SystemEnv.getHtmlLabelName(19009,user.getLanguage());
                
        
        }
       
         else if (tmpid.equals("1"))
        {
                
                sqlwhere += "and (  exists (select 1 from workflow_requestbase where requestid="+tablename+".requestid and creater ";
                if(tmpopt.equals("1"))  sqlwhere+=" in (select id from hrmresource where managerid in ("+tmpvalue+")) ";
                if(tmpopt.equals("2"))  sqlwhere+=" not in (select id from hrmresource where managerid in ("+tmpvalue+") )";
                if (!tmpvalue.equals(""))
                sqlwhere+=")";
                sqlwherecn += SystemEnv.getHtmlLabelName(18760,user.getLanguage())+" ("+SystemEnv.getHtmlLabelName(15080,user.getLanguage());
                if(tmpopt.equals("1"))  sqlwherecn+=SystemEnv.getHtmlLabelName(18805,user.getLanguage())+" ("+tmpname+") "+SystemEnv.getHtmlLabelName(19009,user.getLanguage());
                if(tmpopt.equals("2"))  sqlwherecn+=SystemEnv.getHtmlLabelName(19008,user.getLanguage())+" ("+tmpname+")"+SystemEnv.getHtmlLabelName(19009,user.getLanguage());
                //sqlwherecn+=")";
        
        }
         else if (tmpid.equals("2"))
        {
                
                sqlwhere += "and (  exists (select 1 from workflow_requestbase where requestid="+tablename+".requestid and creater ";
                if(tmpopt.equals("1"))  sqlwhere+=" in (select id from hrmresource where departmentid in ("+tmpvalue+")) ";
                if(tmpopt.equals("2"))  sqlwhere+=" not in (select id from hrmresource where departmentid in ("+tmpvalue+") )";
                if (!tmpvalue.equals(""))
                sqlwhere+=")";
                sqlwherecn += SystemEnv.getHtmlLabelName(18760,user.getLanguage())+" ("+SystemEnv.getHtmlLabelName(15081,user.getLanguage());
                if(tmpopt.equals("1"))  sqlwherecn+=SystemEnv.getHtmlLabelName(18805,user.getLanguage())+" ("+tmpname+") "+SystemEnv.getHtmlLabelName(19009,user.getLanguage());
                if(tmpopt.equals("2"))  sqlwherecn+=SystemEnv.getHtmlLabelName(19008,user.getLanguage())+"("+tmpname +")"+SystemEnv.getHtmlLabelName(19009,user.getLanguage());
                //sqlwherecn+=")";
        
        }
         else if (tmpid.equals("3"))
        {
                
                sqlwhere += "and (  exists (select 1 from workflow_requestbase where requestid="+tablename+".requestid and creater ";
                if(tmpopt.equals("1"))  sqlwhere+=" in (select id from hrmresource where subcompanyid1 in ("+tmpvalue +")) ";
                if(tmpopt.equals("2"))  sqlwhere+=" not in (select id from hrmresource where subcompanyid1 in ("+tmpvalue +") )";
                if (!tmpvalue.equals(""))
                sqlwhere+=")";
                sqlwherecn += SystemEnv.getHtmlLabelName(18760,user.getLanguage())+" ("+SystemEnv.getHtmlLabelName(15577,user.getLanguage());
                if(tmpopt.equals("1"))  sqlwherecn+=SystemEnv.getHtmlLabelName(18805,user.getLanguage())+" ("+tmpname+") "+SystemEnv.getHtmlLabelName(19009,user.getLanguage());
                if(tmpopt.equals("2"))  sqlwherecn+=SystemEnv.getHtmlLabelName(19008,user.getLanguage())+"("+tmpname +")"+SystemEnv.getHtmlLabelName(19009,user.getLanguage());
                //sqlwherecn+=")";
        
        }
        else if((tmphtmltype.equals("1")&& tmptype.equals("1"))||tmphtmltype.equals("2")){//单行文本框、多行文本框
             //  if(!tmpvalue.equals("") && !tmpopt.equals("")){
                     sqlwhere += "and ("+tmpcolname;
                      if(tmpopt.equals("1")){
						if(tmphtmltype.equals("2")) sqlwhere+=" like '"+tmpvalue +"' ";
							else sqlwhere+=" ='"+tmpvalue +"' ";
						}
						if(tmpopt.equals("2")){
						    //QC156787 解决单文本字段属于不属于空值作为批次条件流转错误的问题
							//if(tmphtmltype.equals("2")) sqlwhere+=" not like '"+tmpvalue +"' ";
							//else sqlwhere+=" <>'"+tmpvalue +"' ";
                            if(tmphtmltype.equals("2")){ 
                                sqlwhere+=" not like '"+tmpvalue +"' ";
                            }else{
                                sqlwhere+=" <>'"+tmpvalue +"' ";
                                sqlwhere+=" or "+tmpcolname +" is not null";
                            }
                            
						}
                     if(tmpopt.equals("3"))  sqlwhere+=" like '%"+tmpvalue +"%' ";
                     if(tmpopt.equals("4"))  sqlwhere+=" not like '%"+tmpvalue +"%' ";
             //  }
             //add by xhheng @20050205 for TD 1537
                     sqlwherecn += SystemEnv.getHtmlLabelName(18760,user.getLanguage())+" ("+tmpcolnamecn;
                     if(tmpopt.equals("1"))  sqlwherecn+=" "+SystemEnv.getHtmlLabelName(327,user.getLanguage())+"'"+tmpvalue +"' ";
                     if(tmpopt.equals("2"))  sqlwherecn+=" "+SystemEnv.getHtmlLabelName(15506,user.getLanguage())+"'"+tmpvalue +"' ";
                     if(tmpopt.equals("3"))  sqlwherecn+=" "+SystemEnv.getHtmlLabelName(346,user.getLanguage())+"'"+tmpvalue +"' ";
                     if(tmpopt.equals("4"))  sqlwherecn+=" "+SystemEnv.getHtmlLabelName(15507,user.getLanguage())+" '"+tmpvalue +"' ";
             }
        else if(tmphtmltype.equals("1")&& !tmptype.equals("1")){//数值
                sqlwhere += getSqlWhereByhtype1(tmpopt, tmpcolname, tmpvalue, tmpopt1, tmpvalue1);
                sqlwherecn += getSqlWhereCnByhtype1(user, tmpopt, tmpvalue, tmpopt1, tmpvalue1, tmpcolnamecn);
        }
        else if(tmphtmltype.equals("4")){
                 sqlwhere += "and ("+tmpcolname;
                 if(!tmpvalue.equals("1")) sqlwhere+="<>'1' ";
                 else sqlwhere +="='1' ";
           //add by xhheng @20050205 for TD 1537
                 sqlwherecn += SystemEnv.getHtmlLabelName(18760,user.getLanguage())+" ("+tmpcolnamecn;
                 //td16413
//               if(!tmpvalue.equals("1")) sqlwherecn+=SystemEnv.getHtmlLabelName(15506,user.getLanguage())+"'1' ";
//               else sqlwherecn +=SystemEnv.getHtmlLabelName(327,user.getLanguage())+"'1' ";
               if(!tmpvalue.equals("1")) sqlwherecn+=SystemEnv.getHtmlLabelName(15506,user.getLanguage())+"'" +SystemEnv.getHtmlLabelName(1426,user.getLanguage())+ "' ";
               else sqlwherecn +=SystemEnv.getHtmlLabelName(327,user.getLanguage())+"'" +SystemEnv.getHtmlLabelName(1426,user.getLanguage())+ "' ";            
                 
                 
        }
        else if(tmphtmltype.equals("5")){
             //  if(!tmpvalue.equals("") && !tmpopt.equals("")){
                     sqlwhere += "and ("+tmpcolname;
                     if(tmpopt.equals("1"))  sqlwhere+=" ="+tmpvalue +" ";
                     //if(tmpopt.equals("2"))  sqlwhere+=" <>"+tmpvalue +" ";
                     //TD46131 不等于需要考虑未选择的情况
                     if(tmpopt.equals("2")) {
                     	 if("".equals(tmpvalue)){
                     	 	 sqlwhere+=" <>'"+tmpvalue +"' ";
                     	 	 sqlwhere+=" or "+tmpcolname +" is not null";
                     	 } else {
                     	 	 sqlwhere+=" <>"+tmpvalue +" ";
                     	 	 if("ORACLE".equalsIgnoreCase(rs.getDBType())){
                    			sqlwhere+="or (" + tmpcolname + " is null or " + tmpcolname + " = '')";
                    		 }else{
                    			sqlwhere+="or (" + tmpcolname + " is null)";
                    		 }
                     	 }
                     }
             //add by xhheng @20050205 for TD 1537
                     sqlwherecn += SystemEnv.getHtmlLabelName(18760,user.getLanguage())+" ("+tmpcolnamecn;
                     if(tmpopt.equals("1"))  sqlwherecn+=" "+SystemEnv.getHtmlLabelName(327,user.getLanguage())+"'"+getSelectItem(isbill,tmpfeildid,tmpvalue) +"' ";
                     if(tmpopt.equals("2"))  sqlwherecn+=" "+SystemEnv.getHtmlLabelName(15506,user.getLanguage())+"'"+getSelectItem(isbill,tmpfeildid,tmpvalue) +"' ";
             //  }
        }
        else if(tmphtmltype.equals("3") && (tmptype.equals("4")||tmptype.equals("7")|| tmptype.equals("8")||tmptype.equals("9")||tmptype.equals("16")||tmptype.equals("41")||tmptype.equals("167")||tmptype.equals("169")||tmptype.equals("117")))
        {//部门 客户 项目 文档 请求 41 分权单部门 分权单分部 117
     
        //  if(!tmpvalue.equals("") && !tmpopt.equals("")){
                sqlwhere += "and ("+tmpcolname;
                if(tmpopt.equals("1"))  sqlwhere+=" in ("+tmpvalue +") ";
                if(tmpopt.equals("2"))  sqlwhere+=" not in ("+tmpvalue +") ";
        //  }
        //add by xhheng @20050205 for TD 1537
                sqlwherecn += SystemEnv.getHtmlLabelName(18760,user.getLanguage())+" ("+tmpcolnamecn;
                if(tmpopt.equals("1"))	sqlwherecn+=SystemEnv.getHtmlLabelName(353,user.getLanguage())+" ("+tmpname+") "+SystemEnv.getHtmlLabelName(19009,user.getLanguage());
				if(tmpopt.equals("2"))	sqlwherecn+=SystemEnv.getHtmlLabelName(21473,user.getLanguage())+"("+tmpname +")"+SystemEnv.getHtmlLabelName(19009,user.getLanguage());
                
        }else if(tmphtmltype.equals("3") && tmptype.equals("161")){//自定义单选
        	if(!tmpvalue.equals("") && !tmpopt.equals("")){
	        		if(rs.getDBType().equalsIgnoreCase("oracle")){
	                    sqlwhere += "and ("+tmpcolname;
					}else{
						sqlwhere += "and (convert(varchar(4000), "+tmpcolname+") ";
					}
                    String[] tmpvalue_sz = tmpvalue.split(",");
                    tmpvalue = "";
                    for(int cxx=0; cxx<tmpvalue_sz.length; cxx++){
                    	String tmpvalue_tmp = "'"+Util.null2String(tmpvalue_sz[cxx]).trim()+"',";
                    	tmpvalue = tmpvalue + tmpvalue_tmp;
                    }
                    if(tmpvalue.length() > 0){
                    	tmpvalue = tmpvalue.substring(0, tmpvalue.length()-1);
                    }
                    if(tmpopt.equals("1"))  sqlwhere+=" in ("+tmpvalue +") ";
                    if(tmpopt.equals("2"))  sqlwhere+=" not in ("+tmpvalue +") ";

                    sqlwherecn += SystemEnv.getHtmlLabelName(18760,user.getLanguage())+" ("+tmpcolnamecn;
                    if(tmpopt.equals("1"))  sqlwherecn+=SystemEnv.getHtmlLabelName(353,user.getLanguage())+" ("+tmpname+") "+SystemEnv.getHtmlLabelName(19009,user.getLanguage());
                    if(tmpopt.equals("2"))  sqlwherecn+=SystemEnv.getHtmlLabelName(21473,user.getLanguage())+"("+tmpname +")"+SystemEnv.getHtmlLabelName(19009,user.getLanguage());
        		}
            }
        else if(tmphtmltype.equals("3") && !tmptype.equals("1") && !tmptype.equals("2") && !tmptype.equals("18") && !tmptype.equals("19")&& !tmptype.equals("17")&&
                !tmptype.equals("24")&& !tmptype.equals("160")&&!tmptype.equals("57")&&!tmptype.equals("135")&&!tmptype.equals("37")&&!tmptype.equals("65")&&
                !tmptype.equals("142")&&!tmptype.equals("152")&& !tmptype.equals("166")&& !tmptype.equals("168")&& !tmptype.equals("170")&& !tmptype.equals("194")&& !tmptype.equals("162")&&
                !tmptype.equals("165")&& !tmptype.equals("146") && !tmptype.equals("164")&& !tmptype.equals("224")&& !tmptype.equals("225")&& !tmptype.equals("226")&& !tmptype.equals("227")){
        //  if(!tmpvalue.equals("") && !tmpopt.equals("")){
                sqlwhere += "and ("+tmpcolname;
                if(tmpopt.equals("1"))  sqlwhere+=" ="+tmpvalue +" ";
                if(tmpopt.equals("2"))  sqlwhere+=" <>"+tmpvalue +" ";
        //add by xhheng @20050205 for TD 1537
                sqlwherecn += SystemEnv.getHtmlLabelName(18760,user.getLanguage())+" ("+tmpcolnamecn;
                if(tmpopt.equals("1"))  sqlwherecn+=" "+SystemEnv.getHtmlLabelName(327,user.getLanguage())+"'"+tmpname +"' ";
                if(tmpopt.equals("2"))  sqlwherecn+=" "+SystemEnv.getHtmlLabelName(15506,user.getLanguage())+"'"+tmpname +"' ";
        //  }        
		}
		else if(tmphtmltype.equals("3") &&( tmptype.equals("224")||tmptype.equals("225")||tmptype.equals("226")||tmptype.equals("227"))){//sap	
				   //  if(!tmpvalue.equals("") && !tmpopt.equals("")){
                sqlwhere += "and ("+tmpcolname;
                if(tmpopt.equals("1"))  sqlwhere+=" ='"+tmpvalue +"' ";
                if(tmpopt.equals("2"))  sqlwhere+=" <>'"+tmpvalue +"' ";
		        //add by xhheng @20050205 for TD 1537
		                sqlwherecn += SystemEnv.getHtmlLabelName(18760,user.getLanguage())+" ("+tmpcolnamecn;
		                if(tmpopt.equals("1"))  sqlwherecn+=" "+SystemEnv.getHtmlLabelName(327,user.getLanguage())+"'"+tmpname +"' ";
		                if(tmpopt.equals("2"))  sqlwherecn+=" "+SystemEnv.getHtmlLabelName(15506,user.getLanguage())+"'"+tmpname +"' ";
		        //  }        
		}
		else if(tmphtmltype.equals("3") && tmptype.equals("164")){//分部		
				//TD33245 lv start
				sqlwhere = getSqlwhere164(sqlwhere,tmpcolname,tmpopt,tmpvalue);
				//System.out.println("sqlwhere="+sqlwhere);
				sqlwherecn = getSqlwherecn164(sqlwherecn,user.getLanguage(),tmpopt,tmpcolnamecn,tmpname);	
				//System.out.println("sqlwherecn="+sqlwherecn);
				//TD33245 lv end
		}
        else if(tmphtmltype.equals("3") && (tmptype.equals("1")||tmptype.equals("165")||tmptype.equals("146"))){
            sqlwhere = getSqlwhere3_1_165_146( sqlwhere, tmpcolname, tmpopt, tmpvalue, tmpopt1, tmpvalue1);
      //add by xhheng @20050205 for TD 1537
            sqlwherecn += SystemEnv.getHtmlLabelName(18760,user.getLanguage())+" ("+tmpcolnamecn+" "+SystemEnv.getHtmlLabelName(18761,user.getLanguage());
            if(!tmpvalue.equals("")){
                //if(tmpopt.equals("1"))    sqlwherecn+=" 大于'"+tmpvalue +"' ";
                //if(tmpopt.equals("2"))    sqlwherecn+=" 大于等于'"+tmpvalue +"' ";
                //if(tmpopt.equals("3"))    sqlwherecn+=" 小于'"+tmpvalue +"' ";
                //if(tmpopt.equals("4"))    sqlwherecn+=" 小于等于'"+tmpvalue +"' ";
                //if(tmpopt.equals("5"))    sqlwherecn+=" 等于'"+tmpvalue +"' ";
                //if(tmpopt.equals("6"))    sqlwherecn+=" 不等于'"+tmpvalue +"' ";
                
                if(tmpopt.equals("1"))  sqlwherecn+=" "+SystemEnv.getHtmlLabelName(15508,user.getLanguage())+"'"+tmpvalue +"' ";
                if(tmpopt.equals("2"))  sqlwherecn+=" "+SystemEnv.getHtmlLabelName(325,user.getLanguage())+"'"+tmpvalue +"' ";
                if(tmpopt.equals("3"))  sqlwherecn+=" "+SystemEnv.getHtmlLabelName(15509,user.getLanguage())+"'"+tmpvalue +"' ";
                if(tmpopt.equals("4"))  sqlwherecn+=" "+SystemEnv.getHtmlLabelName(326,user.getLanguage())+"'"+tmpvalue +"' ";
                if(tmpopt.equals("5"))  sqlwherecn+=" "+SystemEnv.getHtmlLabelName(327,user.getLanguage())+"'"+tmpvalue +"' ";
                if(tmpopt.equals("6"))  sqlwherecn+=" "+SystemEnv.getHtmlLabelName(15506,user.getLanguage())+"'"+tmpvalue +"' ";
      
			}
            if(!tmpvalue1.equals("")){
				sqlwherecn+=SystemEnv.getHtmlLabelName(18760,user.getLanguage())+" ";
                //if(tmpopt1.equals("1"))   sqlwherecn+=" 大于'"+tmpvalue1 +"' ";
                //if(tmpopt1.equals("2"))   sqlwherecn+=" 大于等于'"+tmpvalue1 +"' ";
                //if(tmpopt1.equals("3"))   sqlwherecn+=" 小于'"+tmpvalue1 +"' ";
                //if(tmpopt1.equals("4"))   sqlwherecn+=" 小于等于'"+tmpvalue1 +"' ";
                //if(tmpopt1.equals("5"))   sqlwherecn+=" 等于'"+tmpvalue1 +"' ";
                //if(tmpopt1.equals("6"))   sqlwherecn+=" 不等于'"+tmpvalue1 +"' ";
                if(tmpopt1.equals("1")) sqlwherecn+=" "+SystemEnv.getHtmlLabelName(15508,user.getLanguage())+"'"+tmpvalue1 +"' ";
                if(tmpopt1.equals("2")) sqlwherecn+=" "+SystemEnv.getHtmlLabelName(325,user.getLanguage())+"'"+tmpvalue1 +"' ";
                if(tmpopt1.equals("3")) sqlwherecn+=" "+SystemEnv.getHtmlLabelName(15509,user.getLanguage())+"'"+tmpvalue1 +"' ";
                if(tmpopt1.equals("4")) sqlwherecn+=" "+SystemEnv.getHtmlLabelName(326,user.getLanguage())+"'"+tmpvalue1 +"' ";
                if(tmpopt1.equals("5")) sqlwherecn+=" "+SystemEnv.getHtmlLabelName(327,user.getLanguage())+"'"+tmpvalue1 +"' ";
                if(tmpopt1.equals("6")) sqlwherecn+=" "+SystemEnv.getHtmlLabelName(15506,user.getLanguage())+"'"+tmpvalue1 +"' ";
            
            }
            sqlwherecn +=" "+SystemEnv.getHtmlLabelName(18762,user.getLanguage());
        }
        else if(tmphtmltype.equals("3") && tmptype.equals("24")){//职位安全级别
        if(!tmpvalue.equals("")){
                
                if(tmpopt.equals("1"))  sqlwhere += "and ("+tmpcolname+" in ("+tmpvalue ;
                if(tmpopt.equals("2"))  sqlwhere += "and ("+tmpcolname+" not in ("+tmpvalue ;
            }
            if(!tmpvalue.equals("")) sqlwhere +=" )";
            if(!tmpvalue.equals("")){
                sqlwherecn += SystemEnv.getHtmlLabelName(18760,user.getLanguage())+" ("+tmpcolnamecn+" ";
                if(tmpopt.equals("1"))  sqlwherecn+=" "+SystemEnv.getHtmlLabelName(353,user.getLanguage())+"'"+tmpname +"' ";
                if(tmpopt.equals("2"))  sqlwherecn+=" "+SystemEnv.getHtmlLabelName(21473,user.getLanguage())+"'"+tmpname +"' ";

      }
        }//职位安全级别end
        else if(tmphtmltype.equals("3") && (tmptype.equals("2")||tmptype.equals("19"))){
            sqlwhere += "and ("+tmpcolname;
            if(!tmpvalue.equals("")){
                if(tmpopt.equals("1"))  sqlwhere+=" >'"+tmpvalue +"' ";
                if(tmpopt.equals("2"))  sqlwhere+=" >='"+tmpvalue +"' ";
                if(tmpopt.equals("3"))  sqlwhere+=" <'"+tmpvalue +"' ";
                if(tmpopt.equals("4"))  sqlwhere+=" <='"+tmpvalue +"' ";
                if(tmpopt.equals("5"))  sqlwhere+=" ='"+tmpvalue +"' ";
                if(tmpopt.equals("6"))  sqlwhere+=" <>'"+tmpvalue +"' ";

                if(!tmpvalue1.equals(""))
                    sqlwhere += " and "+tmpcolname;
            }
            if(!tmpvalue1.equals("")){
                if(tmpopt1.equals("1")) sqlwhere+=" >'"+tmpvalue1 +"' ";
                if(tmpopt1.equals("2")) sqlwhere+=" >='"+tmpvalue1 +"' ";
                if(tmpopt1.equals("3")) sqlwhere+=" <'"+tmpvalue1 +"' ";
                if(tmpopt1.equals("4")) sqlwhere+=" <='"+tmpvalue1 +"' ";
                if(tmpopt1.equals("5")) sqlwhere+=" ='"+tmpvalue1+"' ";
                if(tmpopt1.equals("6")) sqlwhere+=" <>'"+tmpvalue1 +"' ";
            }
            sqlwherecn += SystemEnv.getHtmlLabelName(18760,user.getLanguage())+" ("+tmpcolnamecn;
            if(!tmpvalue.equals("")){
                //if(tmpopt.equals("1"))    sqlwherecn+=" 大于'"+tmpvalue +"' ";
                //if(tmpopt.equals("2"))    sqlwherecn+=" 大于等于'"+tmpvalue +"' ";
                //if(tmpopt.equals("3"))    sqlwherecn+=" 小于'"+tmpvalue +"' ";
                //if(tmpopt.equals("4"))    sqlwherecn+=" 小于等于'"+tmpvalue +"' ";
                //if(tmpopt.equals("5"))    sqlwherecn+=" 等于'"+tmpvalue +"' ";
                //if(tmpopt.equals("6"))    sqlwherecn+=" 不等于'"+tmpvalue +"' ";
                if(tmpopt.equals("1"))  sqlwherecn+=" "+SystemEnv.getHtmlLabelName(15508,user.getLanguage())+"'"+tmpvalue +"' ";
                if(tmpopt.equals("2"))  sqlwherecn+=" "+SystemEnv.getHtmlLabelName(325,user.getLanguage())+"'"+tmpvalue +"' ";
                if(tmpopt.equals("3"))  sqlwherecn+=" "+SystemEnv.getHtmlLabelName(15509,user.getLanguage())+"'"+tmpvalue +"' ";
                if(tmpopt.equals("4"))  sqlwherecn+=" "+SystemEnv.getHtmlLabelName(326,user.getLanguage())+"'"+tmpvalue +"' ";
                if(tmpopt.equals("5"))  sqlwherecn+=" "+SystemEnv.getHtmlLabelName(327,user.getLanguage())+"'"+tmpvalue +"' ";
                if(tmpopt.equals("6"))  sqlwherecn+=" "+SystemEnv.getHtmlLabelName(15506,user.getLanguage())+"'"+tmpvalue +"' ";

                if(!tmpvalue1.equals(""))
                    sqlwherecn += SystemEnv.getHtmlLabelName(18760,user.getLanguage())+"  "+tmpcolnamecn;
            }
            if(!tmpvalue1.equals("")){
                //if(tmpopt1.equals("1"))   sqlwherecn+=" 大于'"+tmpvalue1 +"' ";
                //if(tmpopt1.equals("2"))   sqlwherecn+=" 大于等于'"+tmpvalue1 +"' ";
                //if(tmpopt1.equals("3"))   sqlwherecn+=" 小于'"+tmpvalue1 +"' ";
                //if(tmpopt1.equals("4"))   sqlwherecn+=" 小于等于'"+tmpvalue1 +"' ";
                //if(tmpopt1.equals("5"))   sqlwherecn+=" 等于'"+tmpvalue1+"' ";
                //if(tmpopt1.equals("6"))   sqlwherecn+=" 不等于'"+tmpvalue1 +"' ";
                
                if(tmpopt1.equals("1")) sqlwherecn+=" "+SystemEnv.getHtmlLabelName(15508,user.getLanguage())+"'"+tmpvalue1 +"' ";
                if(tmpopt1.equals("2")) sqlwherecn+=" "+SystemEnv.getHtmlLabelName(325,user.getLanguage())+"'"+tmpvalue1 +"' ";
                if(tmpopt1.equals("3")) sqlwherecn+=" "+SystemEnv.getHtmlLabelName(15509,user.getLanguage())+"'"+tmpvalue1 +"' ";
                if(tmpopt1.equals("4")) sqlwherecn+=" "+SystemEnv.getHtmlLabelName(326,user.getLanguage())+"'"+tmpvalue1 +"' ";
                if(tmpopt1.equals("5")) sqlwherecn+=" "+SystemEnv.getHtmlLabelName(327,user.getLanguage())+"'"+tmpvalue1+"' ";
                if(tmpopt1.equals("6")) sqlwherecn+=" "+SystemEnv.getHtmlLabelName(15506,user.getLanguage())+"'"+tmpvalue1 +"' ";
            
            }
        }
        else if(tmphtmltype.equals("3") && (tmptype.equals("17") || tmptype.equals("18")||tmptype.equals("160")||tmptype.equals("57")||tmptype.equals("135")||tmptype.equals("37")||tmptype.equals("65")||tmptype.equals("142")||tmptype.equals("152")||tmptype.equals("166")||tmptype.equals("168")||tmptype.equals("170")||tmptype.equals("194")||tmptype.equals("162"))){
            //if(!tmpvalue.equals("") && !tmpopt.equals("")){
            //TD4070 mackjoe at 2006-04-04
            ArrayList templist =Util.TokenizerString(tmpvalue,",");
			if (templist.size()==0){
				if(rs.getDBType().equalsIgnoreCase("oracle"))
						sqlwhere += "and (concat(concat(',',"+tmpcolname+"),',')";
				else
						sqlwhere += "and (','+CONVERT(varchar(8000),"+tmpcolname+")+',' ";
						if(tmpopt.equals("1"))  sqlwhere+=" like '%,"+tmpvalue+",%' ";
						if(tmpopt.equals("2"))  sqlwhere+=" not like '%,"+tmpvalue+",%' ";
			}else{
				for(int n=0;n<templist.size();n++){
					if(n>0) sqlwhere+=") ";
					if(rs.getDBType().equalsIgnoreCase("oracle"))
						sqlwhere += "and (concat(concat(',',"+tmpcolname+"),',')";
					else
						sqlwhere += "and (','+CONVERT(varchar(8000),"+tmpcolname+")+',' ";
					if(tmpopt.equals("1"))  sqlwhere+=" like '%,"+templist.get(n) +",%' ";
					if(tmpopt.equals("2"))  sqlwhere+=" not like '%,"+templist.get(n) +",%' ";
				}
			}
                sqlwherecn += SystemEnv.getHtmlLabelName(18760,user.getLanguage())+" ("+tmpcolnamecn+"";
                if(tmpopt.equals("1"))  sqlwherecn+=" "+SystemEnv.getHtmlLabelName(346,user.getLanguage())+" "+tmpname +" ";
                if(tmpopt.equals("2"))  sqlwherecn+=" "+SystemEnv.getHtmlLabelName(15507,user.getLanguage())+" "+tmpname +" ";
            //}
        }

        sqlwhere +=") ";
    sqlwherecn +=") ";
//System.out.println("sqlwhere="+sqlwhere);
//System.out.println("sqlwherecn="+sqlwherecn);
    }

}
float passtime = -1;
if (fromsrc.equals("1"))
{
request.getSession(true).setAttribute("por"+conid+"_con","");
request.getSession(true).setAttribute("por"+conid+"_con_cn","");
}
if(Util.null2String(request.getParameter("comefrom")).equals("1")){
    if(!sqlwhere.equals(""))
        sqlwhere = sqlwhere.substring(3);
    passtime =  Util.getFloatValue((String)request.getParameter("passtime"),-1);
//add by xhheng @20050205 for TD 1537
  if(!sqlwherecn.equals(""))
    sqlwherecn = sqlwherecn.substring(3);
}else{
    // modify by sean for TD3074
    if(fromBillManagement==1){
        rs.executeSql("select condition , conditioncn , nodepasstime  from workflow_nodelink where id="+linkid) ;
        /*
        if(rs.next()){
            passtime = Util.getFloatValue(rs.getString("nodepasstime"),-1);
            sqlwhere = Util.null2String(rs.getString("condition"));
            sqlwherecn = Util.null2String(rs.getString("conditioncn"));
        }
        */
      //调整字段后新的读取方式开始
		 String strSql = "select condition , conditioncn , nodepasstime  from workflow_nodelink where id="+linkid;
		 weaver.conn.ConnStatement statement=new weaver.conn.ConnStatement();
	   	 statement.setStatementSql(strSql, false);
	   	 statement.executeQuery();
		if(statement.next()){
		  	 if(rs.getDBType().equals("oracle"))
		  	 {
			  		oracle.sql.CLOB theclob = statement.getClob("condition"); 
			  		String readline = "";
			        StringBuffer clobStrBuff = new StringBuffer("");
			        java.io.BufferedReader clobin = new java.io.BufferedReader(theclob.getCharacterStream());
			        while ((readline = clobin.readLine()) != null) clobStrBuff = clobStrBuff.append(readline);
			        clobin.close() ;
			        sqlwhere = clobStrBuff.toString();
			        
			        oracle.sql.CLOB theclob2 = statement.getClob("conditioncn"); 
			  		String readline2 = "";
			        StringBuffer clobStrBuff2 = new StringBuffer("");
			        java.io.BufferedReader clobin2 = new java.io.BufferedReader(theclob2.getCharacterStream());
			        while ((readline2 = clobin2.readLine()) != null) clobStrBuff2 = clobStrBuff2.append(readline2);
			        clobin2.close() ;
			        sqlwhere = clobStrBuff2.toString();
		  	  }else{
		  		  sqlwhere=statement.getString("condition");
		  		  sqlwherecn=statement.getString("conditioncn");
		  }
	  	 
	  	passtime = Util.getFloatValue(statement.getString("nodepasstime"),-1);
		}
	  	//调整字段后新的读取方式结束
    }else{
            passtime = Util.getFloatValue((String)request.getSession(true).getAttribute("por"+conid+"_passtime"),-1);
            sqlwhere = Util.null2String((String)request.getSession(true).getAttribute("por"+conid+"_con"));
           //add by xhheng @20050205 for TD 1537
           sqlwherecn = Util.null2String((String)request.getSession(true).getAttribute("por"+conid+"_con_cn"));
    }
}


if(haspost.equals("1")){
    request.getSession(true).setAttribute("por"+conid+"_con",sqlwhere);

  //add by xhheng @20050205 for TD 1537
  request.getSession(true).setAttribute("por"+conid+"_con_cn",sqlwherecn);
    request.getSession(true).setAttribute("por"+conid+"_passtime",""+passtime);




}

if(isclear.equals("1")){
    request.getSession(true).setAttribute("por"+conid+"_con","");
  //add by xhheng @20050205 for TD 1537
  request.getSession(true).setAttribute("por"+conid+"_con_cn","");

  

}
%>
<BODY>
<script language=vbs>
if "<%=haspost%>" = "1" then
    window.parent.returnvalue = Array("<%=sqlwhere%>","<%=sqlwherecn%>")
    window.parent.close
end if
if "<%=isclear%>" = "1" then
    window.parent.returnvalue = Array("","")
    window.parent.close
end if
</script>

<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(89,user.getLanguage())+",javascript:SearchForm.submit(),_self} " ;
RCMenuHeight += RCMenuHeightStep;
%>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(199,user.getLanguage())+",javascript:SearchForm.reset(),_self} " ;
RCMenuHeight += RCMenuHeightStep;
%>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(826,user.getLanguage())+",javascript:submitData(),_self} " ;
RCMenuHeight += RCMenuHeightStep;
%>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(15504,user.getLanguage())+",javascript:submitClear(),_self} " ;
RCMenuHeight += RCMenuHeightStep;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

<FORM NAME=SearchForm STYLE="margin-bottom:0" action="OperatorCondition.jsp" method="post">
<input type="hidden" value="<%=conid%>" name="id">
<input type="hidden" value="<%=formid%>" name="formid">
<input type=hidden name=isbill value="<%=isbill%>">
<input type=hidden name=haspost value="">
<input type=hidden name=isclear value="">
<input type=hidden name=comefrom value="1">
<input type=hidden name=posttime value="<%=passtime%>">
<input type=hidden name=fromBillManagement value="<%=fromBillManagement%>">
<input type=hidden name=linkid value="<%=linkid%>">

<table width=100% height=100% border="0" cellspacing="0" cellpadding="0">
<colgroup>
<col width="10">
<col width="">
<col width="10">
<tr>
    <td valign="top">
        <TABLE class=Shadow>
        <tr>
        <td valign="top">

<table width=100% class="liststyle">
<COLGROUP>
   <COL width="4%">
   <COL width="25%">
   <COL width="20%">
   <COL width="15%">
   <COL width="18%">
   <COL width="18%">




<TR class=header>

<td colspan=6><%=SystemEnv.getHtmlLabelName(882,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(522,user.getLanguage())%></td>
<td ></td>
</tr>
<TR>
<td><input type='checkbox' name='check_con' value="0" <%if(ids.indexOf("0")!=-1){%> checked <%}%>></td>
<td><%=SystemEnv.getHtmlLabelName(882,user.getLanguage())%></td><!--创建人-->
<td><select class=inputstyle  name="con0_opt"  style="width:100%" onfocus="changelevel('0')" onmouseover="showtitle(this,event)">
<option value="1" <%if((ids.indexOf("0")!=-1)&&((String)opts.get(Util.getIntValue(""+ids.indexOf("0")))).equals("1")){%> selected <%}%> ><%=SystemEnv.getHtmlLabelName(353,user.getLanguage())%></option><!--被包含于-->
<option value="2" <%if((ids.indexOf("0")!=-1)&&((String)opts.get(Util.getIntValue(""+ids.indexOf("0")))).equals("2")){%> selected <%}%> ><%=SystemEnv.getHtmlLabelName(21473,user.getLanguage())%></option><!--不被包含于-->
</select>
 <!--多人力--></td>  
<td  colspan=3><button type="button" class=Browser  onfocus="changelevel('0')" onclick="onShowBrowsers('0','<%=UrlComInfo.getUrlbrowserurl("17")%>','17')"></button>
<input type="hidden" name="con0_value" <%if(ids.indexOf("0")!=-1){%> value="<%=((String)values.get(Util.getIntValue(""+ids.indexOf("0"))))%>"<%}%>>
<input type="hidden" name="con0_name" <%if(ids.indexOf("0")!=-1){%> value="<%=((String)names.get(Util.getIntValue(""+ids.indexOf("0"))))%>"<%}%>>
<span name="con0_valuespan" id="con0_valuespan"><%if(ids.indexOf("0")!=-1){%> <%=((String)names.get(Util.getIntValue(""+ids.indexOf("0"))))%><%}%> </span></td>
</tr>
<TR>
<td><input type='checkbox' name='check_con' value="1" <%if(ids.indexOf("1")!=-1){%> checked <%}%> ></td>    

<td><%=SystemEnv.getHtmlLabelName(15080,user.getLanguage())%></td><!--创建人经理-->
<td><select class=inputstyle  name="con1_opt"   style="width:100%" onfocus="changelevel('1')" onmouseover="showtitle(this,event)">
<option value="1" <%if((ids.indexOf("1")!=-1)&&((String)opts.get(Util.getIntValue(""+ids.indexOf("1")))).equals("1")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(353,user.getLanguage())%></option><!--被包含于-->
<option value="2" <%if((ids.indexOf("1")!=-1)&&((String)opts.get(Util.getIntValue(""+ids.indexOf("1")))).equals("2")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(21473,user.getLanguage())%></option><!--不被包含于-->
</select></td>
<td  colspan=3><button type="button" class=Browser  onfocus="changelevel('1')" onclick="onShowBrowsers('1','<%=UrlComInfo.getUrlbrowserurl("17")%>','17')"></button>
<input type="hidden" name="con1_value" <%if(ids.indexOf("1")!=-1){%> value="<%=((String)values.get(Util.getIntValue(""+ids.indexOf("1"))))%>"<%}%>>
<input type="hidden" name="con1_name" <%if(ids.indexOf("1")!=-1){%> value="<%=((String)names.get(Util.getIntValue(""+ids.indexOf("1"))))%>"<%}%>>
<span name="con1_valuespan" id="con1_valuespan"><%if(ids.indexOf("1")!=-1){%><%=((String)names.get(Util.getIntValue(""+ids.indexOf("1"))))%><%}%> </span></td>
</tr>
<TR>
<td><input type='checkbox' name='check_con' value="2" <%if(ids.indexOf("2")!=-1){%> checked <%}%>></td>

<td><%=SystemEnv.getHtmlLabelName(15081,user.getLanguage())%></td><!--创建本部门-->

<td><select class=inputstyle  name="con2_opt"   style="width:100%" onfocus="changelevel('2')" onmouseover="showtitle(this,event)">
<option value="1" <%if((ids.indexOf("2")!=-1)&&((String)opts.get(Util.getIntValue(""+ids.indexOf("2")))).equals("1")){%> selected <%}%> ><%=SystemEnv.getHtmlLabelName(353,user.getLanguage())%></option><!--被包含于-->
<option value="2" <%if((ids.indexOf("2")!=-1)&&((String)opts.get(Util.getIntValue(""+ids.indexOf("2")))).equals("2")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(21473,user.getLanguage())%></option><!--不被包含于-->
</select></td>
<td  colspan=3><button type="button" class=Browser  onfocus="changelevel('2')" onclick="onShowBrowsers('2','<%=UrlComInfo.getUrlbrowserurl("57")%>','17')"></button>
<input type="hidden" name="con2_value" <%if(ids.indexOf("2")!=-1){%> value="<%=((String)values.get(Util.getIntValue(""+ids.indexOf("2"))))%>"<%}%>>
<input type="hidden" name="con2_name" <%if(ids.indexOf("2")!=-1){%> value="<%=((String)names.get(Util.getIntValue(""+ids.indexOf("2"))))%>"<%}%>>
<span name="con2_valuespan" id="con2_valuespan"> <%if(ids.indexOf("2")!=-1){%> <%=((String)names.get(Util.getIntValue(""+ids.indexOf("2"))))%><%}%></span></td>
</tr>
<TR>
<td><input type='checkbox' name='check_con' value="3" <%if(ids.indexOf("3")!=-1){%> checked <%}%>></td>

<td><%=SystemEnv.getHtmlLabelName(18584,user.getLanguage())%></td><!--创建人本分部-->

<td><select class=inputstyle  name="con3_opt"   style="width:100%" onfocus="changelevel('3')" onmouseover="showtitle(this,event)">
<option value="1" <%if((ids.indexOf("3")!=-1)&&((String)opts.get(Util.getIntValue(""+ids.indexOf("3")))).equals("1")){%> selected <%}%> ><%=SystemEnv.getHtmlLabelName(353,user.getLanguage())%></option><!--被包含于-->
<option value="2" <%if((ids.indexOf("3")!=-1)&&((String)opts.get(Util.getIntValue(""+ids.indexOf("3")))).equals("2")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(21473,user.getLanguage())%></option><!--不被包含于-->
</select></td>
<td  colspan=3><button type="button" class=Browser  onfocus="changelevel('3')" onclick="onShowBrowsers('3','/systeminfo/BrowserMain.jsp?url=/hrm/company/SubcompanyBrowser3.jsp','1')"></button>
<input type="hidden" name="con3_value" <%if(ids.indexOf("3")!=-1){%> value="<%=((String)values.get(Util.getIntValue(""+ids.indexOf("3"))))%>"<%}%>>
<input type="hidden" name="con3_name" <%if(ids.indexOf("3")!=-1){%> value="<%=((String)names.get(Util.getIntValue(""+ids.indexOf("3"))))%>"<%}%>>
<span name="con3_valuespan" id="con3_valuespan"> <%if(ids.indexOf("3")!=-1){%> <%=((String)names.get(Util.getIntValue(""+ids.indexOf("3"))))%><%}%></span></td>
</tr>
<TR class=header>
<td></td>
<td><%=SystemEnv.getHtmlLabelName(261,user.getLanguage())%></td>
<td colspan=4><%=SystemEnv.getHtmlLabelName(15364,user.getLanguage())%></td>
</tr>
<input type='checkbox' name='check_con' style="display:none">
<%
int linecolor=0;
String sql="";
if(isbill.equals("0"))
    //sql = "select workflow_formfield.fieldid as id,fieldname as name,workflow_fieldlable.fieldlable as label,workflow_formdict.fieldhtmltype as htmltype,workflow_formdict.type as type from workflow_formfield,workflow_formdict,workflow_fieldlable where workflow_fieldlable.formid = workflow_formfield.formid and workflow_fieldlable.isdefault = '1' and workflow_fieldlable.fieldid =workflow_formfield.fieldid and workflow_formdict.id = workflow_formfield.fieldid and (workflow_formfield.isdetail<>'1' or workflow_formfield.isdetail is null) and workflow_formfield.formid="+formid;
    //节点信息节点操作者批次条件字段顺序与节点信息节点表单字段里主字段的顺序保持一致（表单）myq 修改 2008.3.18
    sql = "select workflow_formfield.fieldid as id,fieldname as name,workflow_fieldlable.fieldlable as label,workflow_formdict.fieldhtmltype as htmltype,workflow_formdict.type as type, workflow_formdict.fielddbtype as fielddbtype from workflow_formfield,workflow_formdict,workflow_fieldlable where workflow_fieldlable.formid = workflow_formfield.formid and workflow_fieldlable.isdefault = '1' and workflow_fieldlable.fieldid =workflow_formfield.fieldid and workflow_formdict.id = workflow_formfield.fieldid and (workflow_formfield.isdetail<>'1' or workflow_formfield.isdetail is null) and workflow_formfield.formid="+formid+" order by workflow_formfield.isdetail,workflow_formfield.groupid,workflow_formfield.fieldorder";
else if(isbill.equals("1"))
    //sql = "select id as id,fieldname as name,fieldlabel as label,fieldhtmltype as htmltype,type as type from workflow_billfield where billid = "+formid + " and viewtype=0 order by dsporder ";
    //节点信息节点操作者批次条件字段顺序与节点信息节点表单字段里主字段的顺序保持一致（单据）myq 修改 2008.3.18
    sql = "select id as id,fieldname as name,fieldlabel as label,fieldhtmltype as htmltype,type as type, fielddbtype from workflow_billfield where billid = "+formid + " and viewtype=0 order by viewtype,detailtable,dsporder ";

RecordSet.executeSql(sql);
int tmpcount = 4;
while(RecordSet.next()){
int id = RecordSet.getInt("id");
int idvalue= RecordSet.getInt("id");
String htmltype = RecordSet.getString("htmltype");
String type = RecordSet.getString("type");
String name = RecordSet.getString("name");
String label = RecordSet.getString("label");
String fielddbtype = Util.null2String(RecordSet.getString("fielddbtype"));
//伪browser框，不能作为出口条件
if(htmltype.equals("3")&&(UrlComInfo.getUrlbrowserurl(type).equals("")||type.equals("141"))) continue;
if(htmltype.equals("7")||htmltype.equals("6")||(htmltype.equals("2")&&type.equals("2"))) continue;
tmpcount += 1;

id=tmpcount;
%>
 <tr>
<td><input type='checkbox' name='check_con'  value="<%=id%>" <%if(ids.indexOf(""+id)!=-1){%> checked <%}%>></td>
<td> <input type=hidden name="con<%=id%>_id" value="<%=id%>"> 
<input type=hidden name="con<%=id%>_fieldid" value="<%=idvalue%>">
<%
if(isbill.equals("1"))
    label = SystemEnv.getHtmlLabelName(Util.getIntValue(label),user.getLanguage());
%>
<%=Util.toScreen(label,user.getLanguage())%>
<input type=hidden name="con<%=id%>_colname" value="<%=name%>">
<!-- add by xhheng @20050205 for TD 1537 -->
<input type=hidden name="con<%=id%>_colname_cn" value="<%=label%>">
</td>
<input type=hidden name="con<%=id%>_htmltype" value="<%=htmltype%>">
<input type=hidden name="con<%=id%>_type" value="<%=type%>">
<%
if((htmltype.equals("1")&& type.equals("1"))||htmltype.equals("2")){
%>
<td>
<select class=inputstyle  name="con<%=id%>_opt" style="width:100%" onfocus="changelevel('<%=tmpcount%>')" onmouseover="showtitle(this,event)">

<option value="1" <%if((ids.indexOf(""+id)!=-1)&&((String)opts.get(Util.getIntValue(""+ids.indexOf(""+id)))).equals("1")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(327,user.getLanguage())%></option>
<option value="2" <%if((ids.indexOf(""+id)!=-1)&&((String)opts.get(Util.getIntValue(""+ids.indexOf(""+id)))).equals("2")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(15506,user.getLanguage())%></option>
<option value="3" <%if((ids.indexOf(""+id)!=-1)&&((String)opts.get(Util.getIntValue(""+ids.indexOf(""+id)))).equals("3")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(346,user.getLanguage())%></option>
<option value="4" <%if((ids.indexOf(""+id)!=-1)&&((String)opts.get(Util.getIntValue(""+ids.indexOf(""+id)))).equals("4")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(15507,user.getLanguage())%></option>
</select>
</td>
<td colspan=3>
<input type=text class=InputStyle size=12 name="con<%=id%>_value"  onfocus="changelevel('<%=tmpcount%>')"  <%if(ids.indexOf(""+id)!=-1){%> value=<%=((String)values.get(Util.getIntValue(""+ids.indexOf(""+id))))%><%}%>>
</td>
<%}
else if(htmltype.equals("1")&& !type.equals("1")){
%>
<td>
<select class=inputstyle  name="con<%=id%>_opt" style="width:100%" onfocus="changelevel('<%=tmpcount%>')" onmouseover="showtitle(this,event)">
<option value="1" <%if((ids.indexOf(""+id)!=-1)&&((String)opts.get(Util.getIntValue(""+ids.indexOf(""+id)))).equals("1")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(15508,user.getLanguage())%></option>
<option value="2" <%if((ids.indexOf(""+id)!=-1)&&((String)opts.get(Util.getIntValue(""+ids.indexOf(""+id)))).equals("2")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(325,user.getLanguage())%></option>
<option value="3" <%if((ids.indexOf(""+id)!=-1)&&((String)opts.get(Util.getIntValue(""+ids.indexOf(""+id)))).equals("3")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(15509,user.getLanguage())%></option>
<option value="4" <%if((ids.indexOf(""+id)!=-1)&&((String)opts.get(Util.getIntValue(""+ids.indexOf(""+id)))).equals("4")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(326,user.getLanguage())%></option>
<option value="5" <%if((ids.indexOf(""+id)!=-1)&&((String)opts.get(Util.getIntValue(""+ids.indexOf(""+id)))).equals("5")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(327,user.getLanguage())%></option>
<option value="6" <%if((ids.indexOf(""+id)!=-1)&&((String)opts.get(Util.getIntValue(""+ids.indexOf(""+id)))).equals("6")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(15506,user.getLanguage())%></option>
</select>
</td>
<td >
<input type=text class=InputStyle size=12 name="con<%=id%>_value"  onfocus="changelevel('<%=tmpcount%>')" <%if(ids.indexOf(""+id)!=-1){%> value=<%=((String)values.get(Util.getIntValue(""+ids.indexOf(""+id))))%> <%}%>>
</td>
<td>
<select class=inputstyle  name="con<%=id%>_opt1" style="width:100%" onfocus="changelevel('<%=tmpcount%>')" onmouseover="showtitle(this,event)">
<option value="1" <%if((ids.indexOf(""+id)!=-1)&&((String)opt1s.get(Util.getIntValue(""+ids.indexOf(""+id)))).equals("1")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(15508,user.getLanguage())%></option>
<option value="2" <%if((ids.indexOf(""+id)!=-1)&&((String)opt1s.get(Util.getIntValue(""+ids.indexOf(""+id)))).equals("2")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(325,user.getLanguage())%></option>
<option value="3" <%if((ids.indexOf(""+id)!=-1)&&((String)opt1s.get(Util.getIntValue(""+ids.indexOf(""+id)))).equals("3")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(15509,user.getLanguage())%></option>
<option value="4" <%if((ids.indexOf(""+id)!=-1)&&((String)opt1s.get(Util.getIntValue(""+ids.indexOf(""+id)))).equals("4")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(326,user.getLanguage())%></option>
<option value="5" <%if((ids.indexOf(""+id)!=-1)&&((String)opt1s.get(Util.getIntValue(""+ids.indexOf(""+id)))).equals("5")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(327,user.getLanguage())%></option>
<option value="6" <%if((ids.indexOf(""+id)!=-1)&&((String)opt1s.get(Util.getIntValue(""+ids.indexOf(""+id)))).equals("6")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(15506,user.getLanguage())%></option>
</select>
</td>
<td>
<input type=text class=InputStyle size=12 name="con<%=id%>_value1"  onfocus="changelevel('<%=tmpcount%>')"  <%if(ids.indexOf(""+id)!=-1){%> value=<%=((String)value1s.get(Util.getIntValue(""+ids.indexOf(""+id))))%><%}%>>
</td>
<%
}
else if(htmltype.equals("4")){
%>
<td colspan=4>
<input type=checkbox value=1 name="con<%=id%>_value"  onfocus="changelevel('<%=tmpcount%>')" <%if((ids.indexOf(""+id)!=-1)&&((String)values.get(Util.getIntValue(""+ids.indexOf(""+id)))).equals("1")){%> checked <%}%>>
</td>
<%}
else if(htmltype.equals("5")){
%>

<td>
<select class=inputstyle  name="con<%=id%>_opt" style="width:100%" onfocus="changelevel('<%=tmpcount%>')" id="con<%=id%>_opt" onmouseover="showtitle(this,event)">
<option value="1" <%if((ids.indexOf(""+id)!=-1)&&((String)opts.get(Util.getIntValue(""+ids.indexOf(""+id)))).equals("1")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(327,user.getLanguage())%></option>
<option value="2" <%if((ids.indexOf(""+id)!=-1)&&((String)opts.get(Util.getIntValue(""+ids.indexOf(""+id)))).equals("2")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(15506,user.getLanguage())%></option>
</select>
</td><td colspan=3>
<select class=inputstyle  name="con<%=id%>_value" onfocus="changelevel('<%=tmpcount%>')" id="con<%=id%>_value" onmouseover="showtitle(this,event)">
<%
char flag=2;
rs.executeProc("workflow_SelectItemSelectByid",""+idvalue+flag+isbill);
int limitPx = 180;
int maxPx = 0;
int tmpPx = 0;
boolean setTitle = true;
while(rs.next()){
    int tmpselectvalue = rs.getInt("selectvalue");
    String tmpselectname = rs.getString("selectname");
    tmpPx = Util.toScreen(tmpselectname,user.getLanguage()).length()*7 + 25;
    if (tmpPx > maxPx)
    maxPx = tmpPx;
%>
<option value="<%=tmpselectvalue%>"  <%if((ids.indexOf(""+id)!=-1)&&((String)values.get(Util.getIntValue(""+ids.indexOf(""+id)))).equals(""+tmpselectvalue)){%> selected <%}%>><%=Util.toScreen(tmpselectname,user.getLanguage())%></option>
<%}%>
<%
maxPx = (maxPx >= limitPx) ? limitPx : maxPx;
%>
</select>
<%
if (maxPx == limitPx) {
%>
    <script language="javascript">
    setTimeout(function()
	{
		document.all('con<%=id%>_value').style.width="<%=limitPx%>px";
	},200)
    </script>
<%
}
%>
</td>
<%} else if(htmltype.equals("3") && !type.equals("1")&& !type.equals("4")&& !type.equals("57")&& !type.equals("7")&& !type.equals("8")&& !type.equals("16")&& !type.equals("135")&& !type.equals("9")&& !type.equals("37")&& !type.equals("41")&& !type.equals("2")&& !type.equals("18")&& !type.equals("19")&& !type.equals("17")&& !type.equals("24")&& !type.equals("65")&& !type.equals("142")&& !type.equals("152")&& !type.equals("160")&& !type.equals("166")&& !type.equals("168")&& !type.equals("170")&& !type.equals("194")&& !type.equals("162")&& !type.equals("161")&& !type.equals("165")&& !type.equals("167")&& !type.equals("169")&& !type.equals("117") && !type.equals("164")&& !type.equals("224")&& !type.equals("225")&& !type.equals("226")&& !type.equals("227")){
%>
<td>
<select class=inputstyle  name="con<%=id%>_opt" style="width:100%" onfocus="changelevel('<%=tmpcount%>')" onmouseover="showtitle(this,event)">
<option value="1" <%if((ids.indexOf(""+id)!=-1)&&((String)opts.get(Util.getIntValue(""+ids.indexOf(""+id)))).equals("1")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(327,user.getLanguage())%></option>
<option value="2" <%if((ids.indexOf(""+id)!=-1)&&((String)opts.get(Util.getIntValue(""+ids.indexOf(""+id)))).equals("2")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(15506,user.getLanguage())%></option>
</select>
</td>
<td colspan=3>
<button type="button" class=Browser  onfocus="changelevel('<%=tmpcount%>')" onclick="onShowBrowser('<%=id%>','<%=UrlComInfo.getUrlbrowserurl(type)%>')"></button>
<input type=hidden name="con<%=id%>_value" <%if(ids.indexOf(""+id)!=-1){%> value="<%=((String)values.get(Util.getIntValue(""+ids.indexOf(""+id))))%>"<%}%>>
<input type=hidden name="con<%=id%>_name" <%if(ids.indexOf(""+id)!=-1){%> value="<%=((String)names.get(Util.getIntValue(""+ids.indexOf(""+id))))%>"<%}%>>
<span name="con<%=id%>_valuespan" id="con<%=id%>_valuespan"> <%if(ids.indexOf(""+id)!=-1){%><%=((String)names.get(Util.getIntValue(""+ids.indexOf(""+id))))%><%}%></span>
</td>
<%} else if(htmltype.equals("3") && type.equals("164")){//TD33245 lv 分部
%>
<td>
<%=getOption164(ids, id, tmpcount,user.getLanguage(), opts)%>
</td>
<td colspan=3>
<button type="button" class=Browser  onfocus="changelevel('<%=tmpcount%>')" onclick="onShowBrowsers('<%=id%>','/systeminfo/BrowserMain.jsp?url=/hrm/company/SubcompanyBrowser3.jsp','1')"></button>
<input type=hidden name="con<%=id%>_value" <%if(ids.indexOf(""+id)!=-1){%> value="<%=((String)values.get(Util.getIntValue(""+ids.indexOf(""+id))))%>"<%}%>>
<input type=hidden name="con<%=id%>_name" <%if(ids.indexOf(""+id)!=-1){%> value="<%=((String)names.get(Util.getIntValue(""+ids.indexOf(""+id))))%>"<%}%>>
<span name="con<%=id%>_valuespan" id="con<%=id%>_valuespan"> <%if(ids.indexOf(""+id)!=-1){%><%=((String)names.get(Util.getIntValue(""+ids.indexOf(""+id))))%><%}%></span>
</td>
<%} else if(htmltype.equals("3") && (type.equals("4")||type.equals("7")|| type.equals("8")|| type.equals("16")||type.equals("9")||type.equals("41")||type.equals("167")||type.equals("169") ||type.equals("37") )){
%>
<td>
<select class=inputstyle  name="con<%=id%>_opt" style="width:100%" onfocus="changelevel('<%=tmpcount%>')" onmouseover="showtitle(this,event)">
<option value="1" <%if((ids.indexOf(""+id)!=-1)&&((String)opts.get(Util.getIntValue(""+ids.indexOf(""+id)))).equals("1")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(353,user.getLanguage())%></option>
<option value="2" <%if((ids.indexOf(""+id)!=-1)&&((String)opts.get(Util.getIntValue(""+ids.indexOf(""+id)))).equals("2")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(21473,user.getLanguage())%></option>
</select>
</td>
<td colspan=3>
<%
    if(type.equals("37")){
%>
<button type="button" class=Browser  onfocus="changelevel('<%=tmpcount%>')" onclick="onShowBrowsers('<%=id%>','<%=UrlComInfo.getUrlbrowserurl("9")%>','0')"></button>
<%
    } else {
%>
<button type="button" class=Browser  onfocus="changelevel('<%=tmpcount%>')" onclick="onShowBrowsers('<%=id%>','<%=UrlComInfo.getUrlbrowserurl(UrlComInfo.changeBroserToMulBroser(type))%>','0')"></button>
<%
    }
%>
<input type=hidden name="con<%=id%>_value" <%if(ids.indexOf(""+id)!=-1){%> value="<%=((String)values.get(Util.getIntValue(""+ids.indexOf(""+id))))%>"<%}%>>
<input type=hidden name="con<%=id%>_name" <%if(ids.indexOf(""+id)!=-1){%> value="<%=((String)names.get(Util.getIntValue(""+ids.indexOf(""+id))))%>"<%}%>>
<span name="con<%=id%>_valuespan" id="con<%=id%>_valuespan"> <%if(ids.indexOf(""+id)!=-1){%><%=((String)names.get(Util.getIntValue(""+ids.indexOf(""+id))))%><%}%></span>
</td>
<%} else if(htmltype.equals("3") && (type.equals("135")||type.equals("65")||type.equals("142")||type.equals("152")||type.equals("117"))){
%>
<td>
<select class=inputstyle  name="con<%=id%>_opt" style="width:100%" onfocus="changelevel('<%=tmpcount%>')" onmouseover="showtitle(this,event)">
<option value="1" <%if((ids.indexOf(""+id)!=-1)&&((String)opts.get(Util.getIntValue(""+ids.indexOf(""+id)))).equals("1")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(346,user.getLanguage())%></option>
<option value="2" <%if((ids.indexOf(""+id)!=-1)&&((String)opts.get(Util.getIntValue(""+ids.indexOf(""+id)))).equals("2")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(15507,user.getLanguage())%></option>
</select>
</td>
<td colspan=3>
<%
    if(type.equals("135")){
%>
<button type="button" class=Browser  onfocus="changelevel('<%=tmpcount%>')" onclick="onShowBrowsers('<%=id%>','<%=UrlComInfo.getUrlbrowserurl("8")%>','0')"></button>
<%
    }
%>
<%
    if(type.equals("37")){
%>
<button type="button" class=Browser  onfocus="changelevel('<%=tmpcount%>')" onclick="onShowBrowsers('<%=id%>','<%=UrlComInfo.getUrlbrowserurl("9")%>','0')"></button>
<%
    }
%>
<%
    if(type.equals("65")){
%>
<button type="button" class=Browser  onfocus="changelevel('<%=tmpcount%>')" onclick="onShowBrowser('<%=id%>','/systeminfo/BrowserMain.jsp?url=/hrm/roles/HrmRolesBrowser.jsp')"></button>
<%
    }
%>
<%
    if(type.equals("142")){
%>
<button type="button" class=Browser  onfocus="changelevel('<%=tmpcount%>')" onclick="onShowBrowser('<%=id%>','/systeminfo/BrowserMain.jsp?url=/docs/sendDoc/DocReceiveUnitBrowserSingle.jsp')"></button>
<%
    }
%>
<%
    if(type.equals("152")){
%>
<button type="button" class=Browser  onfocus="changelevel('<%=tmpcount%>')" onclick="onShowBrowsers('<%=id%>','<%=UrlComInfo.getUrlbrowserurl("16")%>','0')"></button>
<%
    }
%>
<%
    if(type.equals("117")){
%>
<button type="button" class=Browser  onfocus="changelevel('<%=tmpcount%>')" onclick="onShowBrowsers('<%=id%>','<%=UrlComInfo.getUrlbrowserurl("41")%>','0')"></button>
<%
    }
%>
<input type=hidden name="con<%=id%>_value" <%if(ids.indexOf(""+id)!=-1){%> value="<%=((String)values.get(Util.getIntValue(""+ids.indexOf(""+id))))%>"<%}%>>
<input type=hidden name="con<%=id%>_name" <%if(ids.indexOf(""+id)!=-1){%> value="<%=((String)names.get(Util.getIntValue(""+ids.indexOf(""+id))))%>"<%}%>>
<span name="con<%=id%>_valuespan" id="con<%=id%>_valuespan"> <%if(ids.indexOf(""+id)!=-1){%><%=((String)names.get(Util.getIntValue(""+ids.indexOf(""+id))))%><%}%></span>
</td>
<%}else if(htmltype.equals("3") && (type.equals("57")||type.equals("168"))){
%>
<td>
<select class=inputstyle  name="con<%=id%>_opt" style="width:100%" onfocus="changelevel('<%=tmpcount%>')" onmouseover="showtitle(this,event)">
<option value="1" <%if((ids.indexOf(""+id)!=-1)&&((String)opts.get(Util.getIntValue(""+ids.indexOf(""+id)))).equals("1")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(346,user.getLanguage())%></option>
<option value="2" <%if((ids.indexOf(""+id)!=-1)&&((String)opts.get(Util.getIntValue(""+ids.indexOf(""+id)))).equals("2")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(15507,user.getLanguage())%></option>
</select>
</td>
<td colspan=3>
<%if(type.equals("57")){%>
<button type="button" class=Browser  onfocus="changelevel('<%=tmpcount%>')" onclick="onShowBrowser('<%=id%>','<%=UrlComInfo.getUrlbrowserurl("4")%>')"></button>
<%}else{%>
<button type="button" class=Browser  onfocus="changelevel('<%=tmpcount%>')" onclick="onShowBrowser('<%=id%>','<%=UrlComInfo.getUrlbrowserurl("167")%>')"></button>
<%}%>
<input type=hidden name="con<%=id%>_value" <%if(ids.indexOf(""+id)!=-1){%> value="<%=((String)values.get(Util.getIntValue(""+ids.indexOf(""+id))))%>"<%}%>>
<input type=hidden name="con<%=id%>_name" <%if(ids.indexOf(""+id)!=-1){%> value="<%=((String)names.get(Util.getIntValue(""+ids.indexOf(""+id))))%>"<%}%>>
<span name="con<%=id%>_valuespan" id="con<%=id%>_valuespan"> <%if(ids.indexOf(""+id)!=-1){%><%=((String)names.get(Util.getIntValue(""+ids.indexOf(""+id))))%><%}%></span>
</td>
<%}else if(htmltype.equals("3") && type.equals("162")){//自定义多选
%>
<td>
<select class=inputstyle  name="con<%=id%>_opt" style="width:100%" onfocus="changelevel('<%=tmpcount%>')" onmouseover="showtitle(this,event)">
<option value="1" <%if((ids.indexOf(""+id)!=-1)&&((String)opts.get(Util.getIntValue(""+ids.indexOf(""+id)))).equals("1")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(346,user.getLanguage())%></option>
<option value="2" <%if((ids.indexOf(""+id)!=-1)&&((String)opts.get(Util.getIntValue(""+ids.indexOf(""+id)))).equals("2")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(15507,user.getLanguage())%></option>
</select>
</td>
<td colspan=3>
<button type="button" class=Browser  onfocus="changelevel('<%=tmpcount%>')" onclick="onShowBrowser2('<%=id%>','<%=UrlComInfo.getUrlbrowserurl("161")+"?type="+fielddbtype%>')"></button>
<input type=hidden name="con<%=id%>_value" <%if(ids.indexOf(""+id)!=-1){%> value="<%=((String)values.get(Util.getIntValue(""+ids.indexOf(""+id))))%>"<%}%>>
<input type=hidden name="con<%=id%>_name" <%if(ids.indexOf(""+id)!=-1){%> value="<%=((String)names.get(Util.getIntValue(""+ids.indexOf(""+id))))%>"<%}%>>
<span name="con<%=id%>_valuespan" id="con<%=id%>_valuespan"> <%if(ids.indexOf(""+id)!=-1){%><%=((String)names.get(Util.getIntValue(""+ids.indexOf(""+id))))%><%}%></span>
</td>
<%}else if(htmltype.equals("3") && type.equals("161")){//自定义单选
%>
<td>
<select class=inputstyle  name="con<%=id%>_opt" style="width:100%" onfocus="changelevel('<%=tmpcount%>')" onmouseover="showtitle(this,event)">
<option value="1" <%if((ids.indexOf(""+id)!=-1)&&((String)opts.get(Util.getIntValue(""+ids.indexOf(""+id)))).equals("1")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(353,user.getLanguage())%></option>
<option value="2" <%if((ids.indexOf(""+id)!=-1)&&((String)opts.get(Util.getIntValue(""+ids.indexOf(""+id)))).equals("2")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(21473,user.getLanguage())%></option>
</select>
</td>
<td colspan=3>
<button type="button" class=Browser  onfocus="changelevel('<%=tmpcount%>')" onclick="onShowBrowser3('<%=id%>','<%=UrlComInfo.getUrlbrowserurl("162")+"?type="+fielddbtype%>')"></button>
<input type=hidden name="con<%=id%>_value" <%if(ids.indexOf(""+id)!=-1){%> value="<%=((String)values.get(Util.getIntValue(""+ids.indexOf(""+id))))%>"<%}%>>
<input type=hidden name="con<%=id%>_name" <%if(ids.indexOf(""+id)!=-1){%> value="<%=((String)names.get(Util.getIntValue(""+ids.indexOf(""+id))))%>"<%}%>>
<span name="con<%=id%>_valuespan" id="con<%=id%>_valuespan"> <%if(ids.indexOf(""+id)!=-1){%><%=((String)names.get(Util.getIntValue(""+ids.indexOf(""+id))))%><%}%></span>
</td>
<%}else if(htmltype.equals("3") &&(type.equals("224")||type.equals("225")||type.equals("226")||type.equals("227"))){//自定义单选
%>
<td>
<select class=inputstyle  name="con<%=id%>_opt" style="width:100%" onfocus="changelevel('<%=tmpcount%>')" onmouseover="showtitle(this,event)">
<option value="1" <%if((ids.indexOf(""+id)!=-1)&&((String)opts.get(Util.getIntValue(""+ids.indexOf(""+id)))).equals("1")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(327,user.getLanguage())%></option>
<option value="2" <%if((ids.indexOf(""+id)!=-1)&&((String)opts.get(Util.getIntValue(""+ids.indexOf(""+id)))).equals("2")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(15506,user.getLanguage())%></option>
</select>
</td>
<td colspan=3>
<button type="button" class=Browser  onfocus="changelevel('<%=tmpcount%>')" onclick="onShowBrowser4('<%=type%>','<%="?type="+fielddbtype%>','<%=idvalue%>',this)"></button>
<input type=hidden name="con<%=id%>_value" <%if(ids.indexOf(""+id)!=-1){%> value="<%=((String)values.get(Util.getIntValue(""+ids.indexOf(""+id))))%>"<%}%>>
<input type=hidden name="con<%=id%>_name" <%if(ids.indexOf(""+id)!=-1){%> value="<%=((String)names.get(Util.getIntValue(""+ids.indexOf(""+id))))%>"<%}%>>
<span name="con<%=id%>_valuespan" id="con<%=id%>_valuespan"> <%if(ids.indexOf(""+id)!=-1){%><%=((String)names.get(Util.getIntValue(""+ids.indexOf(""+id))))%><%}%></span>
</td>
<%}
else if(htmltype.equals("3") && (type.equals("1")||type.equals("165")||type.equals("146"))){
%>
<td >
<select class=inputstyle  name="con<%=id%>_opt" style="width:100%" onfocus="changelevel('<%=tmpcount%>')" onmouseover="showtitle(this,event)">
<option value="1" <%if((ids.indexOf(""+id)!=-1)&&((String)opts.get(Util.getIntValue(""+ids.indexOf(""+id)))).equals("1")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(15508,user.getLanguage())%></option>
<option value="2" <%if((ids.indexOf(""+id)!=-1)&&((String)opts.get(Util.getIntValue(""+ids.indexOf(""+id)))).equals("2")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(325,user.getLanguage())%></option>
<option value="3" <%if((ids.indexOf(""+id)!=-1)&&((String)opts.get(Util.getIntValue(""+ids.indexOf(""+id)))).equals("3")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(15509,user.getLanguage())%></option>
<option value="4" <%if((ids.indexOf(""+id)!=-1)&&((String)opts.get(Util.getIntValue(""+ids.indexOf(""+id)))).equals("4")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(326,user.getLanguage())%></option>
<option value="5" <%if((ids.indexOf(""+id)!=-1)&&((String)opts.get(Util.getIntValue(""+ids.indexOf(""+id)))).equals("5")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(327,user.getLanguage())%></option>
<option value="6" <%if((ids.indexOf(""+id)!=-1)&&((String)opts.get(Util.getIntValue(""+ids.indexOf(""+id)))).equals("6")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(15506,user.getLanguage())%></option>
</select>
</td>
<td>
<input type=text class=InputStyle size=12 name="con<%=id%>_value"  onfocus="changelevel('<%=tmpcount%>')" <%if(ids.indexOf(""+id)!=-1){%> value=<%=((String)values.get(Util.getIntValue(""+ids.indexOf(""+id))))%> <%}%>>
</td>
<td >
<select class=inputstyle  name="con<%=id%>_opt1" style="width:100%" onfocus="changelevel('<%=tmpcount%>')" onmouseover="showtitle(this,event)">
<option value="1" <%if((ids.indexOf(""+id)!=-1)&&((String)opt1s.get(Util.getIntValue(""+ids.indexOf(""+id)))).equals("1")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(15508,user.getLanguage())%></option>
<option value="2" <%if((ids.indexOf(""+id)!=-1)&&((String)opt1s.get(Util.getIntValue(""+ids.indexOf(""+id)))).equals("2")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(325,user.getLanguage())%></option>
<option value="3" <%if((ids.indexOf(""+id)!=-1)&&((String)opt1s.get(Util.getIntValue(""+ids.indexOf(""+id)))).equals("3")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(15509,user.getLanguage())%></option>
<option value="4" <%if((ids.indexOf(""+id)!=-1)&&((String)opt1s.get(Util.getIntValue(""+ids.indexOf(""+id)))).equals("4")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(326,user.getLanguage())%></option>
<option value="5" <%if((ids.indexOf(""+id)!=-1)&&((String)opt1s.get(Util.getIntValue(""+ids.indexOf(""+id)))).equals("5")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(327,user.getLanguage())%></option>
<option value="6" <%if((ids.indexOf(""+id)!=-1)&&((String)opt1s.get(Util.getIntValue(""+ids.indexOf(""+id)))).equals("6")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(15506,user.getLanguage())%></option>
</select>
</td>
<td >
<input type=text class=InputStyle size=12 name="con<%=id%>_value1"  onfocus="changelevel('<%=tmpcount%>')"  <%if(ids.indexOf(""+id)!=-1){%> value=<%=((String)value1s.get(Util.getIntValue(""+ids.indexOf(""+id))))%><%}%>>
</td>
<%}else if(htmltype.equals("3") && type.equals("24")){//职位的安全级别
%>
<td >
<select class=inputstyle  name="con<%=id%>_opt" style="width:100%" onfocus="changelevel('<%=tmpcount%>')" onmouseover="showtitle(this,event)">
<option value="1" <%if((ids.indexOf(""+id)!=-1)&&((String)opts.get(Util.getIntValue(""+ids.indexOf(""+id)))).equals("1")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(353,user.getLanguage())%></option>
<option value="2" <%if((ids.indexOf(""+id)!=-1)&&((String)opts.get(Util.getIntValue(""+ids.indexOf(""+id)))).equals("2")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(21473,user.getLanguage())%></option>

</select>
</td>
<td>
<button type="button" class=Browser  onfocus="changelevel('<%=tmpcount%>')" onclick="onShowBrowserjob('<%=id%>','/hrm/jobtitles/MutiJobTitlesBrowser.jsp')"></button>
<input type=hidden name="con<%=id%>_value" <%if(ids.indexOf(""+id)!=-1){%> value="<%=((String)values.get(Util.getIntValue(""+ids.indexOf(""+id))))%>"<%}%>>
<input type=hidden name="con<%=id%>_name" <%if(ids.indexOf(""+id)!=-1){%> value="<%=((String)names.get(Util.getIntValue(""+ids.indexOf(""+id))))%>"<%}%>>
<span name="con<%=id%>_valuespan" id="con<%=id%>_valuespan"> <%if(ids.indexOf(""+id)!=-1){%><%=((String)names.get(Util.getIntValue(""+ids.indexOf(""+id))))%><%}%></span>
</td>
<%}//职位安全级别end

else if(htmltype.equals("3") &&( type.equals("2") || type.equals("19"))){
%>
<td >
<select class=inputstyle  name="con<%=id%>_opt" style="width:100%" onfocus="changelevel('<%=tmpcount%>')" onmouseover="showtitle(this,event)">
<option value="1" <%if((ids.indexOf(""+id)!=-1)&&((String)opts.get(Util.getIntValue(""+ids.indexOf(""+id)))).equals("1")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(15508,user.getLanguage())%></option>
<option value="2" <%if((ids.indexOf(""+id)!=-1)&&((String)opts.get(Util.getIntValue(""+ids.indexOf(""+id)))).equals("2")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(325,user.getLanguage())%></option>
<option value="3" <%if((ids.indexOf(""+id)!=-1)&&((String)opts.get(Util.getIntValue(""+ids.indexOf(""+id)))).equals("3")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(15509,user.getLanguage())%></option>
<option value="4" <%if((ids.indexOf(""+id)!=-1)&&((String)opts.get(Util.getIntValue(""+ids.indexOf(""+id)))).equals("4")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(326,user.getLanguage())%></option>
<option value="5" <%if((ids.indexOf(""+id)!=-1)&&((String)opts.get(Util.getIntValue(""+ids.indexOf(""+id)))).equals("5")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(327,user.getLanguage())%></option>
<option value="6" <%if((ids.indexOf(""+id)!=-1)&&((String)opts.get(Util.getIntValue(""+ids.indexOf(""+id)))).equals("6")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(15506,user.getLanguage())%></option>
</select>
</td>
<td>
<button type="button" class=Browser  onfocus="changelevel('<%=tmpcount%>')"  
<%if(type.equals("2")){%>
 onclick="onSearchWFDate(con<%=id%>_valuespan,con<%=id%>_value)"
<%}else{%>
 onclick ="onSearchWFTime(con<%=id%>_valuespan,con<%=id%>_value)"
<%}%>
 ></button>
<input type=hidden name="con<%=id%>_value" <%if(ids.indexOf(""+id)!=-1){%> value="<%=((String)values.get(Util.getIntValue(""+ids.indexOf(""+id))))%>"<%}%>>
<span name="con<%=id%>_valuespan" id="con<%=id%>_valuespan"> <%if(ids.indexOf(""+id)!=-1){%><%=((String)values.get(Util.getIntValue(""+ids.indexOf(""+id))))%><%}%></span>
</td>
<td >
<select class=inputstyle  name="con<%=id%>_opt1" style="width:100%" onfocus="changelevel('<%=tmpcount%>')" onmouseover="showtitle(this,event)">
<option value="1" <%if((ids.indexOf(""+id)!=-1)&&((String)opt1s.get(Util.getIntValue(""+ids.indexOf(""+id)))).equals("1")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(15508,user.getLanguage())%></option>
<option value="2" <%if((ids.indexOf(""+id)!=-1)&&((String)opt1s.get(Util.getIntValue(""+ids.indexOf(""+id)))).equals("2")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(325,user.getLanguage())%></option>
<option value="3" <%if((ids.indexOf(""+id)!=-1)&&((String)opt1s.get(Util.getIntValue(""+ids.indexOf(""+id)))).equals("3")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(15509,user.getLanguage())%></option>
<option value="4" <%if((ids.indexOf(""+id)!=-1)&&((String)opt1s.get(Util.getIntValue(""+ids.indexOf(""+id)))).equals("4")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(326,user.getLanguage())%></option>
<option value="5" <%if((ids.indexOf(""+id)!=-1)&&((String)opt1s.get(Util.getIntValue(""+ids.indexOf(""+id)))).equals("5")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(327,user.getLanguage())%></option>
<option value="6" <%if((ids.indexOf(""+id)!=-1)&&((String)opt1s.get(Util.getIntValue(""+ids.indexOf(""+id)))).equals("6")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(15506,user.getLanguage())%></option>
</select>
</td>
<td >
<button type="button" class=Browser  onfocus="changelevel('<%=tmpcount%>')"  
<%if(type.equals("2")){%>
 onclick="onSearchWFDate(con<%=id%>_value1span,con<%=id%>_value1)"
<%}else{%>
 onclick ="onSearchWFTime(con<%=id%>_value1span,con<%=id%>_value1)"
<%}%>
 ></button>
<input type=hidden name="con<%=id%>_value1" <%if(ids.indexOf(""+id)!=-1){%> value="<%=((String)value1s.get(Util.getIntValue(""+ids.indexOf(""+id))))%>"<%}%>>
<span name="con<%=id%>_value1span" id="con<%=id%>_value1span"> <%if(ids.indexOf(""+id)!=-1){%><%=((String)value1s.get(Util.getIntValue(""+ids.indexOf(""+id))))%><%}%></span>
</td>
<%} else if(htmltype.equals("3") && type.equals("17")){
%>
<td >
<select class=inputstyle  name="con<%=id%>_opt" style="width:100%" onfocus="changelevel('<%=tmpcount%>')" onmouseover="showtitle(this,event)">
<option value="1" <%if((ids.indexOf(""+id)!=-1)&&((String)opts.get(Util.getIntValue(""+ids.indexOf(""+id)))).equals("1")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(346,user.getLanguage())%></option>
<option value="2" <%if((ids.indexOf(""+id)!=-1)&&((String)opts.get(Util.getIntValue(""+ids.indexOf(""+id)))).equals("2")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(15507,user.getLanguage())%></option>
</select>
</td>
<td colspan=3>
<button type="button" class=Browser  onfocus="changelevel('<%=tmpcount%>')" onclick="onShowBrowser('<%=id%>','/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp')"></button>
<input type=hidden name="con<%=id%>_value" <%if(ids.indexOf(""+id)!=-1){%> value="<%=((String)values.get(Util.getIntValue(""+ids.indexOf(""+id))))%>"<%}%>>
<input type=hidden name="con<%=id%>_name" <%if(ids.indexOf(""+id)!=-1){%> value="<%=((String)names.get(Util.getIntValue(""+ids.indexOf(""+id))))%>"<%}%>>
<span name="con<%=id%>_valuespan" id="con<%=id%>_valuespan"> <%if(ids.indexOf(""+id)!=-1){%><%=((String)names.get(Util.getIntValue(""+ids.indexOf(""+id))))%><%}%></span>
</td>
<%} else if(htmltype.equals("3") && type.equals("18")){
%>
<td >
<select class=inputstyle  name="con<%=id%>_opt" style="width:100%" onfocus="changelevel('<%=tmpcount%>')" onmouseover="showtitle(this,event)">
<option value="1" <%if((ids.indexOf(""+id)!=-1)&&((String)opts.get(Util.getIntValue(""+ids.indexOf(""+id)))).equals("1")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(346,user.getLanguage())%></option>
<option value="2" <%if((ids.indexOf(""+id)!=-1)&&((String)opts.get(Util.getIntValue(""+ids.indexOf(""+id)))).equals("2")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(15507,user.getLanguage())%></option>
</select>
</td>
<td colspan=3>
<button type="button" class=Browser  onfocus="changelevel('<%=tmpcount%>')" onclick="onShowBrowser('<%=id%>','/systeminfo/BrowserMain.jsp?url=/CRM/data/CustomerBrowser.jsp')"></button>
<input type=hidden name="con<%=id%>_value" <%if(ids.indexOf(""+id)!=-1){%> value="<%=((String)values.get(Util.getIntValue(""+ids.indexOf(""+id))))%>"<%}%>>
<input type=hidden name="con<%=id%>_name" <%if(ids.indexOf(""+id)!=-1){%> value="<%=((String)names.get(Util.getIntValue(""+ids.indexOf(""+id))))%>"<%}%>>
<span name="con<%=id%>_valuespan" id="con<%=id%>_valuespan"> <%if(ids.indexOf(""+id)!=-1){%><%=((String)names.get(Util.getIntValue(""+ids.indexOf(""+id))))%><%}%></span>
</td>
<%}
     else if(htmltype.equals("3") && (type.equals("160")||type.equals("166"))){
%>
<td >
<select class=inputstyle  name="con<%=id%>_opt" style="width:100%" onfocus="changelevel('<%=tmpcount%>')" onmouseover="showtitle(this,event)">
<option value="1" <%if((ids.indexOf(""+id)!=-1)&&((String)opts.get(Util.getIntValue(""+ids.indexOf(""+id)))).equals("1")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(346,user.getLanguage())%></option>
<option value="2" <%if((ids.indexOf(""+id)!=-1)&&((String)opts.get(Util.getIntValue(""+ids.indexOf(""+id)))).equals("2")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(15507,user.getLanguage())%></option>
</select>
</td>
<td colspan=3>
<button type="button" class=Browser  onfocus="changelevel('<%=tmpcount%>')" onclick="onShowBrowser('<%=id%>','/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp')"></button>
<input type=hidden name="con<%=id%>_value" <%if(ids.indexOf(""+id)!=-1){%> value="<%=((String)values.get(Util.getIntValue(""+ids.indexOf(""+id))))%>"<%}%>>
<input type=hidden name="con<%=id%>_name" <%if(ids.indexOf(""+id)!=-1){%> value="<%=((String)names.get(Util.getIntValue(""+ids.indexOf(""+id))))%>"<%}%>>
<span name="con<%=id%>_valuespan" id="con<%=id%>_valuespan"> <%if(ids.indexOf(""+id)!=-1){%><%=((String)names.get(Util.getIntValue(""+ids.indexOf(""+id))))%><%}%></span>
</td>
<%} else if(htmltype.equals("3") && (type.equals("170")||type.equals("194"))){
%>
<td >
<select class=inputstyle  name="con<%=id%>_opt" style="width:100%" onfocus="changelevel('<%=tmpcount%>')" onmouseover="showtitle(this,event)">
<option value="1" <%if((ids.indexOf(""+id)!=-1)&&((String)opts.get(Util.getIntValue(""+ids.indexOf(""+id)))).equals("1")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(346,user.getLanguage())%></option>
<option value="2" <%if((ids.indexOf(""+id)!=-1)&&((String)opts.get(Util.getIntValue(""+ids.indexOf(""+id)))).equals("2")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(15507,user.getLanguage())%></option>
</select>
</td>
<td colspan=3>
<button type="button" class=Browser  onfocus="changelevel('<%=tmpcount%>')" onclick="onShowBrowser('<%=id%>','/systeminfo/BrowserMain.jsp?url=/hrm/company/SubcompanyBrowser.jsp')"></button>
<input type=hidden name="con<%=id%>_value" <%if(ids.indexOf(""+id)!=-1){%> value="<%=((String)values.get(Util.getIntValue(""+ids.indexOf(""+id))))%>"<%}%>>
<input type=hidden name="con<%=id%>_name" <%if(ids.indexOf(""+id)!=-1){%> value="<%=((String)names.get(Util.getIntValue(""+ids.indexOf(""+id))))%>"<%}%>>
<span name="con<%=id%>_valuespan" id="con<%=id%>_valuespan"> <%if(ids.indexOf(""+id)!=-1){%><%=((String)names.get(Util.getIntValue(""+ids.indexOf(""+id))))%><%}%></span>
</td>
<%}%>
</tr>


<%
}%>
          <TR class=header>
          <TH colSpan=6><%=SystemEnv.getHtmlLabelName(15364,user.getLanguage())%></TH></TR>
<tr>
<td   colspan=6>
<%=sqlwherecn%>
</td><tr>        
</table>
</td>
        </tr>
        </TABLE>
    </td>
</tr>
</table>

</FORM></BODY>
<SCRIPT language="javascript" src="/js/datetime_wev8.js"></script>
<SCRIPT language="javascript" src="/js/selectDateTime_wev8.js"></script>
<SCRIPT language="javascript" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
</HTML>
<SCRIPT LANGUAGE=VBS>
Sub btnok_onclick()
    document.all("haspost").value="1"
     document.SearchForm.submit
End Sub

Sub btnclear_onclick()
     document.all("isclear").value="1"
     document.SearchForm.submit
End Sub


sub onShowBrowser(id,url)
        id1 = window.showModalDialog(url&"?&selectedids="&document.all("con"+id+"_value").value)
        if NOT isempty(id1) then
                if id1(0)<> "" then
                document.all("con"+id+"_valuespan").innerHtml = id1(1)
                document.all("con"+id+"_value").value=id1(0)
                document.all("con"+id+"_name").value=id1(1)
            else
                document.all("con"+id+"_valuespan").innerHtml = empty
                document.all("con"+id+"_value").value=""
                document.all("con"+id+"_name").value=""
            end if
        end if
end sub
sub onShowBrowser1(id,url,type1)
    if type1= 1 then
        id1 = window.showModalDialog(url,,"dialogHeight:320px;dialogwidth:275px")
        document.all("con"+id+"_valuespan").innerHtml = id1
        document.all("con"+id+"_value").value=id1
    elseif type1=2 then
        id1 = window.showModalDialog(url,,"dialogHeight:320px;dialogwidth:275px")
        document.all("con"+id+"_value1span").innerHtml = id1
        document.all("con"+id+"_value1").value=id1
    end if
end sub

sub changelevel(tmpindex)
        document.SearchForm.check_con(Cint(tmpindex)).checked = true

end sub
sub onShowBrowser2(id,url)
        id1 = window.showModalDialog(url)
        if NOT isempty(id1) then
                if id1(0)<> "" then
                document.all("con"+id+"_valuespan").innerHtml = id1(1)
                document.all("con"+id+"_value").value=id1(0)
                document.all("con"+id+"_name").value=id1(1)
            else
                document.all("con"+id+"_valuespan").innerHtml = empty
                document.all("con"+id+"_value").value=""
                document.all("con"+id+"_name").value=""
            end if
        end if
end sub
sub onShowBrowser3(id,url)
        id1 = window.showModalDialog(url)
        if NOT isempty(id1) then
            if id1(0)<> "" then
				ids = doReturnSpanHtml(id1(0))
				names = doReturnSpanHtml(id1(1))
				descs = doReturnSpanHtml(id1(2))
                sHtml = ""
				while InStr(ids,",") <> 0
					curid = Mid(ids,1,InStr(ids,","))
					curname = Mid(names,1,InStr(names,",")-1)
					curdesc = Mid(descs,1,InStr(descs,",")-1)
					ids = Mid(ids,InStr(ids,",")+1,Len(ids))
					names = Mid(names,InStr(names,",")+1,Len(names))
					descs = Mid(descs,InStr(descs,",")+1,Len(descs))
					sHtml = sHtml&"<a title='"&curdesc&"' >"&curname&"</a>&nbsp"
				wend
				sHtml = sHtml&"<a title='"&descs&"'>"&names&"</a>&nbsp"
				document.all("con"+id+"_valuespan").innerHtml = sHtml
				document.all("con"+id+"_value").value=doReturnSpanHtml(id1(0))
				document.all("con"+id+"_name").value=doReturnSpanHtml(id1(1))
            else
                document.all("con"+id+"_valuespan").innerHtml = empty
                document.all("con"+id+"_value").value=""
                document.all("con"+id+"_name").value=""
            end if
        end if
end sub
</script>
   <script language="javascript">
   
 var iTop = (window.screen.availHeight-30-550)/2+"px"; //获得窗口的垂直位置;
 var iLeft = (window.screen.availWidth-10-550)/2+"px"; //获得窗口的水平位置;
function onShowBrowsers(id,url,types){
   idvalue=$("input[name=con"+id+"_value]").val();
   var datas="";
   if (types="1") {
  		datas = window.showModalDialog(url+"&selectedids="+idvalue+"&selectedDepartmentIds="+idvalue,"","dialogTop="+iTop+";dialogLeft="+iLeft+";dialogHeight=550px;dialogWidth=550px;");
   }else{
  		datas = window.showModalDialog(url+"?resourceids="+idvalue,"","dialogTop="+iTop+";dialogLeft="+iLeft+";dialogHeight=550px;dialogWidth=550px;");
   }
   if(datas){
           if (datas.id!= ""){
	           if (url != "/systeminfo/BrowserMain.jsp?url=/workflow/request/RequestBrowser.jsp?isrequest=1") {
		           $("#con"+id+"_valuespan").html(datas.name.substr(1,datas.name.length));
		           $("input[name=con"+id+"_value]").val(datas.id.substr(1,datas.id.length));
		           $("input[name=con"+id+"_name]").val(datas.name.substr(1,datas.name.length));
		       } else {
		       	   $("#con"+id+"_valuespan").html(datas.name);
		           $("input[name=con"+id+"_value]").val(datas.id);
		           $("input[name=con"+id+"_name]").val(datas.name);
		       }
			}else{
				$("#con"+id+"_valuespan").html("");
	           $("input[name=con"+id+"_value]").val("");
	           $("input[name=con"+id+"_name]").val("");
			}
	}
}

function onShowBrowserjob(id,url){
	url= url+"?selectedids="+$("input[name=con"+id+"_value]").val()
	datas = window.showModalDialog(url);
	if(datas){
	     if(datas.id!=""){
	    	 spanNameHtml=doReturnSpanHtml(datas.name);
			$("#con"+id+"_valuespan").html(spanNameHtml);
			$("input[name=con"+id+"_value]").val(doReturnSpanHtml(datas.id));
			$("input[name=con"+id+"_name]").val(spanNameHtml);
	    }else{
	    	$("#con"+id+"_valuespan").html("");
			$("input[name=con"+id+"_value]").val("");
			$("input[name=con"+id+"_name]").val("");
		}
	}
}
   
   
   function doReturnSpanHtml(obj){
		var t_x = obj.substring(0, 1);
		if(t_x == ','){
			t_x = obj.substring(1, obj.length);
		}else{
			t_x = obj;
		}
		return t_x;
	}
function submitData()
{btnok_onclick();
}

function submitClear()
{
    btnclear_onclick();
}
function onShowBrowserByType164(id,type){
	selectObj = document.all("con"+id+"_opt");
	selectValue = selectObj.options[selectObj.selectedIndex].value;
	var url = "";
	if(selectValue == '3' || selectValue == '4' ){		
		onShowBrowsers(id,'<%=UrlComInfo.getUrlbrowserurl(UrlComInfo.changeBroserToMulBroser("167"))%>','0');
	}else if(selectValue == '1' || selectValue == '2' ){		
		onShowBrowser(id,'<%=UrlComInfo.getUrlbrowserurl("164")%>');
	}
}
function onShowBrowser4(id,url,fieldid,obj){
		if(id=="224"||id=="225"){
				//?type=bs|13088&fromNode=1&fromNodeFormid=-313
				var temp=window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/interface/sapSingleBrowser.jsp"+url+"|"+fieldid+"&fromNode=1&fromNodeFormid=<%=formid%>&fromNodeWfid=<%=wfid%>&fromReportisbill=<%=isbill%>");
				if(temp){
					$(obj).next().val(temp.id);//id
					$(obj).next().next().val(temp.name);//name值
					$(obj).next().next().next().html(temp.name);//显示值
				}
		}else{
				var temp=window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/integration/sapSingleBrowser.jsp"+url+"|"+fieldid+"&fromNode=1");
				if(temp){
					$(obj).next().val(temp[0]);//id
					$(obj).next().next().val(temp[1]);//name值
					$(obj).next().next().next().html(temp[1]);//显示值
				}
		}
}
</script>
<%!
	String getSelectItem(String isbill,String fieldid,String fieldvalue){
		String SelectItemName = "";
		weaver.conn.RecordSet rs = new weaver.conn.RecordSet();
		rs.executeSql("select selectname from workflow_selectitem where isbill = '"+isbill+"' and fieldid='"+fieldid+"' and selectvalue= '" + fieldvalue+"'");
		while(rs.next()){
			SelectItemName = rs.getString("selectname");
		}
		if(SelectItemName.equals("")){
			SelectItemName = fieldvalue;
		}
		return SelectItemName;		
	}

//Modify by lizhaoqi for 40686
private String 	getSqlWhereByhtype1(String tmpopt, String tmpcolname, String tmpvalue, String tmpopt1, String tmpvalue1) {
	//判断值是否为数值
	boolean isValue;
	try{
	  double val = Double.parseDouble(tmpvalue);
	  isValue = true;
	}catch(Exception e){
	  isValue = false;
	}
	
	//判断数据库类型
	String dbType= new weaver.conn.RecordSet().getDBType();
	boolean isSqlServer = dbType.equals("sqlserver");
	
	String sqlwhere = "and ( ";
	if(isValue){
		if(isSqlServer){
		    sqlwhere += " convert(decimal(15,4), replace(" + tmpcolname + ",',','')) ";
		}else{
		  	sqlwhere += " Cast(replace(" + tmpcolname + ", ',', '') AS number(15, 4))";
		}
	} else {
	  	sqlwhere += tmpcolname;
	}
    
    if(!tmpvalue.equals("")){
        if(tmpopt.equals("1"))  sqlwhere+=" >"+tmpvalue +" ";
        if(tmpopt.equals("2"))  sqlwhere+=" >="+tmpvalue +" ";
        if(tmpopt.equals("3"))  sqlwhere+=" <"+tmpvalue +" ";
        if(tmpopt.equals("4"))  sqlwhere+=" <="+tmpvalue +" ";
        if(tmpopt.equals("5"))  sqlwhere+=" ="+tmpvalue +" ";
        if(tmpopt.equals("6"))  sqlwhere+=" <>"+tmpvalue +" ";

      	try{
      	  double val = Double.parseDouble(tmpvalue1);
      	  isValue = true;
      	}catch(Exception e){
      	  isValue = false;
      	}
        if(!tmpvalue1.equals("")){
            sqlwhere += " and ";
            if(isValue){
          		if(isSqlServer){
        		    sqlwhere += " convert(decimal(15,4), replace(" + tmpcolname + ",',','')) ";
        		}else{
        		  	sqlwhere += " Cast(replace(" + tmpcolname + ", ',', '') AS number(15, 4))";
        		}
            } else {
                sqlwhere += tmpcolname;
            }
        }
    }
    if(!tmpvalue1.equals("")){
        if(tmpopt1.equals("1")) sqlwhere+=" >"+tmpvalue1 +" ";
        if(tmpopt1.equals("2")) sqlwhere+=" >="+tmpvalue1 +" ";
        if(tmpopt1.equals("3")) sqlwhere+=" <"+tmpvalue1 +" ";
        if(tmpopt1.equals("4")) sqlwhere+=" <="+tmpvalue1 +" ";
        if(tmpopt1.equals("5")) sqlwhere+=" ="+tmpvalue1+" ";
        if(tmpopt1.equals("6")) sqlwhere+=" <>"+tmpvalue1 +" ";
    }
    return sqlwhere;
}

private String 	getSqlWhereCnByhtype1(User user, String tmpopt, String tmpvalue, String tmpopt1, String tmpvalue1, String tmpcolnamecn) {
	String sqlwherecn = "";
	//add by xhheng @20050205 for TD 1537
    sqlwherecn += SystemEnv.getHtmlLabelName(18760,user.getLanguage())+" ("+tmpcolnamecn;
    if(!tmpvalue.equals("")){
        if(tmpopt.equals("1"))  sqlwherecn+=" "+SystemEnv.getHtmlLabelName(15508,user.getLanguage())+"'"+tmpvalue +"' ";
        if(tmpopt.equals("2"))  sqlwherecn+=" "+SystemEnv.getHtmlLabelName(325,user.getLanguage())+"'"+tmpvalue +"' ";
        if(tmpopt.equals("3"))  sqlwherecn+=" "+SystemEnv.getHtmlLabelName(15509,user.getLanguage())+"'"+tmpvalue +"' ";
        if(tmpopt.equals("4"))  sqlwherecn+=" "+SystemEnv.getHtmlLabelName(326,user.getLanguage())+"'"+tmpvalue +"' ";
        if(tmpopt.equals("5"))  sqlwherecn+=" "+SystemEnv.getHtmlLabelName(327,user.getLanguage())+"'"+tmpvalue +"' ";
        if(tmpopt.equals("6"))  sqlwherecn+=" "+SystemEnv.getHtmlLabelName(15506,user.getLanguage())+"'"+tmpvalue +"' ";


        if(!tmpvalue1.equals(""))
            sqlwherecn += SystemEnv.getHtmlLabelName(18760,user.getLanguage())+"  "+tmpcolnamecn;
    }
    if(!tmpvalue1.equals("")){
        if(tmpopt1.equals("1")) sqlwherecn+=" "+SystemEnv.getHtmlLabelName(15508,user.getLanguage())+"'"+tmpvalue1 +"' ";
        if(tmpopt1.equals("2")) sqlwherecn+=" "+SystemEnv.getHtmlLabelName(325,user.getLanguage())+"'"+tmpvalue1 +"' ";
        if(tmpopt1.equals("3")) sqlwherecn+=" "+SystemEnv.getHtmlLabelName(15509,user.getLanguage())+"'"+tmpvalue1 +"' ";
        if(tmpopt1.equals("4")) sqlwherecn+=" "+SystemEnv.getHtmlLabelName(326,user.getLanguage())+"'"+tmpvalue1 +"' ";
        if(tmpopt1.equals("5")) sqlwherecn+=" "+SystemEnv.getHtmlLabelName(327,user.getLanguage())+"'"+tmpvalue1+"' ";
        if(tmpopt1.equals("6")) sqlwherecn+=" "+SystemEnv.getHtmlLabelName(15506,user.getLanguage())+"'"+tmpvalue1 +"' ";
    }
    return sqlwherecn;
}

	String getSqlwhere164(String sqlwhere,String tmpcolname,String tmpopt,String tmpvalue){		
		sqlwhere += "and ("+tmpcolname;		
		if(tmpopt.equals("1"))  sqlwhere+=" in ("+tmpvalue +") ";
		if(tmpopt.equals("2"))  sqlwhere+=" not in ("+tmpvalue +") ";

		return sqlwhere;
	}

	String getSqlwherecn164(String sqlwherecn,int languageId,String tmpopt,String tmpcolnamecn,String tmpname){
		sqlwherecn += SystemEnv.getHtmlLabelName(18760,languageId)+" ("+tmpcolnamecn;
		if(tmpopt.equals("1"))  sqlwherecn+=SystemEnv.getHtmlLabelName(353,languageId)+" ("+tmpname+") "+SystemEnv.getHtmlLabelName(19009,languageId);
		if(tmpopt.equals("2"))  sqlwherecn+=SystemEnv.getHtmlLabelName(21473,languageId)+"("+tmpname +")"+SystemEnv.getHtmlLabelName(19009,languageId);
		
		return sqlwherecn;
	}

	String getOption164(ArrayList ids,int id,int tmpcount,int languageId,ArrayList opts){
		String html = "" + 
		"<select class=inputstyle  name=\"con"+id+"_opt\" style=\"width:100%\" onfocus=\"changelevel('"+tmpcount+"')\" onmouseover=\"showtitle(this,event)\" >" +		
		"<option value=\"1\" " + (((ids.indexOf(""+id)!=-1)&&((String)opts.get(Util.getIntValue(""+ids.indexOf(""+id)))).equals("1"))?" selected " : "") +">"+SystemEnv.getHtmlLabelName(353,languageId)+"</option>" +
		"<option value=\"2\" " + (((ids.indexOf(""+id)!=-1)&&((String)opts.get(Util.getIntValue(""+ids.indexOf(""+id)))).equals("2"))?" selected " : "") +">"+SystemEnv.getHtmlLabelName(21473,languageId)+"</option>" +
		"</select>";

		return html;
	}

	String getSqlwhere3_1_165_146(String sqlwhere,String tmpcolname,String tmpopt,String tmpvalue,String tmpopt1,String tmpvalue1){
		sqlwhere += "and ("+tmpcolname+" in (select id from HrmResource where seclevel ";
		if(!tmpvalue.equals("")){
			if(tmpopt.equals("1"))  sqlwhere+=" >"+tmpvalue +" ";
			if(tmpopt.equals("2"))  sqlwhere+=" >="+tmpvalue +" ";
			if(tmpopt.equals("3"))  sqlwhere+=" <"+tmpvalue +" ";
			if(tmpopt.equals("4"))  sqlwhere+=" <="+tmpvalue +" ";
			if(tmpopt.equals("5"))  sqlwhere+=" ="+tmpvalue +" ";
			if(tmpopt.equals("6"))  sqlwhere+=" <>"+tmpvalue +" ";

			if(!tmpvalue1.equals(""))
				sqlwhere += " and seclevel ";
		}
		if(!tmpvalue1.equals("")){
			if(tmpopt1.equals("1")) sqlwhere+=" >"+tmpvalue1 +" ";
			if(tmpopt1.equals("2")) sqlwhere+=" >="+tmpvalue1 +" ";
			if(tmpopt1.equals("3")) sqlwhere+=" <"+tmpvalue1 +" ";
			if(tmpopt1.equals("4")) sqlwhere+=" <="+tmpvalue1 +" ";
			if(tmpopt1.equals("5")) sqlwhere+=" ="+tmpvalue1+" ";
			if(tmpopt1.equals("6")) sqlwhere+=" <>"+tmpvalue1 +" ";
		}
		sqlwhere +=" )";

		return sqlwhere;
	}
%>