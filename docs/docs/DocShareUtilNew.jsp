
<%@ page language="java" contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.*" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.systeminfo.SystemEnv" %>
<%@ page import="weaver.hrm.*" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="DocViewer" class="weaver.docs.docs.DocViewer" scope="page"/>
<jsp:useBean id="AppDetachComInfo" class="weaver.hrm.appdetach.AppDetachComInfo" scope="page"/>
<jsp:useBean id="SpopForDoc" class="weaver.splitepage.operate.SpopForDoc" scope="page"/>
<%@ page import="weaver.docs.networkdisk.server.PublishNetWorkFile" %>

<%
	User user = HrmUserVarify.getUser (request , response) ;
	if(user == null)  return ;
	
	int docid = Util.getIntValue(request.getParameter("docid"),-1);
	String shareIds = Util.null2String(request.getParameter("shareIds"));
    String  method=Util.null2String(request.getParameter("method"));
	//int userLanguage = user.getLanguage();

//3:共享
//user info
int userid_share=user.getUID();
String logintype_share = user.getLogintype();
String userSeclevel_share = user.getSeclevel();
String userType_share = ""+user.getType();
String userdepartment_share = ""+user.getUserDepartment();
String usersubcomany_share = ""+user.getUserSubCompany1();

boolean canEdit = false;
boolean canShare = false ;
String userInfo=logintype_share+"_"+userid_share+"_"+userSeclevel_share+"_"+userType_share+"_"+userdepartment_share+"_"+usersubcomany_share;
ArrayList PdocList = SpopForDoc.getDocOpratePopedom(""+docid,userInfo);
if (((String)PdocList.get(1)).equals("true")) canEdit = true ;
if (((String)PdocList.get(3)).equals("true")) canShare = true ;
if(canEdit){
    canShare = true;
}
String isDialog = Util.null2String(request.getParameter("isdialog"));

	if(method.equals("delMulti")){
	    if(!canShare){
			out.println("0");
		    return;
	    }		
		String[] arrayShareId=Util.TokenizerString2(shareIds,",");
		if(arrayShareId!=null) {
			for(int i=0;i<arrayShareId.length;i++){
				int tempShareId=Util.getIntValue(arrayShareId[i],-1);
				if(tempShareId==-1) continue;
				RecordSet.executeProc("DocShare_Delete",arrayShareId[i]);
			}

			DocViewer.setDocShareByDoc(""+docid);	
			
			String actionid = Util.null2String(request.getParameter("actionid"));
			String datasourceid = Util.null2String(request.getParameter("datasourceid"));
			if("netdisk".equals(actionid) && datasourceid.contains(",")){//网盘文件发布到系统
			    PublishNetWorkFile publishNetWorkFile = new PublishNetWorkFile();
			    boolean b = publishNetWorkFile.recordShare(docid,datasourceid);
			    if(!b){
			        out.println("0");
			        return;
			    }
			}
		}
		out.println("1");
		return;
	} else if(method.equals("addMulti")){
	    if(!canShare){
	    	if(isDialog.equals("1")){
    	  	String noDownload = Util.null2String(request.getParameter("noDownload"));
        	response.sendRedirect("/docs/docs/DocShareAddBrowser.jsp?isdialog=1&message=1&para=2_"+docid+"&noDownload="+noDownload+"&tab=1");
    	  }
		    return;
	    }
			String[] shareValues = request.getParameterValues("txtShareDetail"); 
			if (shareValues!=null) {
				
				List scopes = AppDetachComInfo.getAppDetachScopes(user.getUID()+"");
				if(scopes!=null&&scopes.size()>0){
					List shareValueList = new ArrayList();
					String tseclevel = "0";
					String tsharelevel = "0";
					String tdownloadlevel = "1";
					boolean hasAll = false;
					
					for(int i=0;i<shareValues.length;i++) {
						String shareValue = shareValues[i];
						if(shareValue.startsWith("5_")){
							hasAll = true;
							String[] paras = Util.TokenizerString2(shareValues[i],"_");
							tseclevel=paras[3] ;
							tsharelevel=paras[4];
							if(paras.length >= 6) {
								tdownloadlevel=paras[5];
							}
						} else {
							shareValueList.add(shareValue);
						}
					}
					for(int i=0;hasAll&&i<scopes.size();i++) {
						Map scope = (Map) scopes.get(i);
						String shareValue = scope.get("type") + "_" + scope.get("content") + "_" + Util.null2o((String)scope.get("rolelevel")) + "_" + tseclevel + "_" + tsharelevel + "_" + tdownloadlevel;
						shareValueList.add(shareValue);
					}
					if(hasAll) shareValues = (String[]) shareValueList.toArray(new String[shareValueList.size()]);
				}
				
				for (int i=0;i<shareValues.length;i++){
				   
					//out.println(shareValues[i]+"<br>");
					String[] paras = Util.TokenizerString2(shareValues[i],"_");
					String sharetype = paras[0];
					String seclevel=paras[3] ;
					String sharelevel=paras[4] ;
					/** td12005 start*/
					String downloadlevel = "1";
					if(paras.length >= 6) {
						downloadlevel=paras[5];
					}
					/** td12005 end*/
					
					char flag=Util.getSeparator();
					String ProcPara = "";

					String userid = "0" ;
					String departmentid = "0" ;
					String subcompanyid="0";
					String roleid = "0" ;
					String foralluser = "0" ;
					String crmid="0";
					String orgGroupId="0";
					String rolelevel="0";
					int sharecrm=0;
					if(sharetype.equals("4")) {
						roleid = paras[1] ;
						rolelevel=paras[2] ;
					}



					if(sharetype.equals("5")) foralluser = "1" ;
					// for TD.4240 edit by wdl
					/*
					if(sharetype.equals("2")) { //分部
					   subcompanyid = paras[1] ;
					}*/
				

					if ("1".equals(sharetype)||"3".equals(sharetype)||"9".equals(sharetype)||sharetype.equals("2")||sharetype.equals("6")){  //1:多人力资源    3:多部门   9://多客户...2:多分部
						String tempStrs[]=Util.TokenizerString2(paras[1],",");
						for(int k=0;k<tempStrs.length;k++){
							userid="";
							departmentid="";
							crmid="";
							subcompanyid="";
							orgGroupId="0";
							
							String tempStr = tempStrs[k];
							if ("1".equals(sharetype)) userid=tempStr;
							if ("3".equals(sharetype)) departmentid=tempStr;
							if ("9".equals(sharetype)) crmid=tempStr;
							if ("2".equals(sharetype)) subcompanyid=tempStr;
							if(sharetype.equals("6")) orgGroupId = tempStr ;
							// end
							
							ProcPara = ""+docid;
							ProcPara += flag+sharetype;
							ProcPara += flag+seclevel;
							ProcPara += flag+rolelevel;
							ProcPara += flag+sharelevel;
							ProcPara += flag+userid;
							ProcPara += flag+subcompanyid;
							ProcPara += flag+departmentid;
							ProcPara += flag+roleid;
							ProcPara += flag+foralluser;
							ProcPara += flag+crmid ;              //  crmid 
							ProcPara += flag+orgGroupId;
							ProcPara += flag+downloadlevel ;
							RecordSet.executeProc("DocShare_IFromDocSecCategoryDL",ProcPara);
							/** td12005 end*/
						}                       
					} else {    
					   String tempUserId=""+user.getUID();
					   if("80".equals(sharetype)||"81".equals(sharetype)||"84".equals(sharetype)||"85".equals(sharetype)||"-80".equals(sharetype)||"-81".equals(sharetype)){ //文档创建者ID
						 String strSql="select doccreaterid from docdetail where id="+docid;
						 RecordSet.executeSql(strSql);
						 if (RecordSet.next()){
						   tempUserId=Util.null2String(RecordSet.getString(1));
						 }                     
					   }                    

						ProcPara = ""+docid;
						ProcPara += flag+sharetype;
						ProcPara += flag+seclevel;
						ProcPara += flag+rolelevel;
						ProcPara += flag+sharelevel;
						ProcPara += flag+tempUserId;
						ProcPara += flag+subcompanyid;
						ProcPara += flag+departmentid;
						ProcPara += flag+roleid;
						ProcPara += flag+foralluser;
						ProcPara += flag+"0" ;              //  crmid 
						ProcPara += flag+orgGroupId;
                        /** td12005 start*/
                        //RecordSet.executeProc("DocShare_IFromDocSecCategory",ProcPara);
                        ProcPara += flag+downloadlevel ;
                        RecordSet.executeProc("DocShare_IFromDocSecCategoryDL",ProcPara);
                        /** td12005 end*/
					}
				
					//for (int j=0;j<paras.length;j++){
					//   out.println(paras[j]+"<br>");
					//}
					//out.println("==========================");
				}
			}	
			
    	  DocViewer.setDocShareByDoc(""+docid);	
    	  if(isDialog.equals("1")){
    	  	String noDownload = Util.null2String(request.getParameter("noDownload"));
        	response.sendRedirect("/docs/docs/DocShareAddBrowser.jsp?isdialog=1&isclose=2&para=2_"+docid+"&noDownload="+noDownload+"&tab=1");
    	  }
		  return;
	} else if(method.equals("getCanShare")){
		RecordSet.executeSql("select d2.allownModiMshareL,d2.allownModiMshareW,d2.shareable from docdetail d1,DocSecCategory d2 where d1.seccategory=d2.id and d1.id=" + docid);
		int isAllowModiMShare = 0;
		int isAllowModiNMShare = 0;
		if (RecordSet.next()) {
			isAllowModiMShare = Util.getIntValue(Util.null2String(RecordSet.getString("allownModiMshareL")),0);
			isAllowModiNMShare = Util.getIntValue(Util.null2String(RecordSet.getString("shareable")),0);
		}
		out.println(isAllowModiMShare+","+isAllowModiNMShare);
		return;
	}
%>