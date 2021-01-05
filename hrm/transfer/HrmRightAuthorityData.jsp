
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@page import="weaver.hrm.authority.domain.*,weaver.hrm.authority.manager.*"%>
<%@ include file="/hrm/header.jsp" %>
<!-- added by wcd 2014-10-13 -->
<jsp:useBean id="RolesComInfo" class="weaver.hrm.roles.RolesComInfo" scope="page"/>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page" />
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page" />
<jsp:useBean id="JobTitlesComInfo" class="weaver.hrm.job.JobTitlesComInfo" scope="page" />
<%
	String fromid = Tools.vString(request.getParameter("fromid"));
	String toid = Tools.vString(request.getParameter("toid"));
	String transferType = Tools.vString(request.getParameter("transferType"),"resource");
	String authorityTag = Tools.vString(request.getParameter("authorityTag"),"transfer");
	String fromname = "";
	if(fromid.length() > 0){
		if(transferType.equals("resource")) {
			fromname = ResourceComInfo.getResourcename(fromid);
		} else if(transferType.equals("department")) {
			fromname = DepartmentComInfo.getDepartmentname(fromid);
		} else if(transferType.equals("subcompany")) {
			fromname = SubCompanyComInfo.getSubCompanyname(fromid);
		} else if(transferType.equals("role")) {
			fromname = RolesComInfo.getRolesRemark(fromid);
		}	else if(transferType.equals("jobtitle")) {
			fromname = JobTitlesComInfo.getJobTitlesname(fromid);
		}
	}
	String toname = "";
	if(toid.length() > 0){
		String[] toids = toid.split(",");
		for(String _toid : toids){
			if(transferType.equals("resource")) {
				toname += ResourceComInfo.getResourcename(_toid)+",";
			} else if(transferType.equals("department")) {
				toname += DepartmentComInfo.getDepartmentname(_toid)+",";
			} else if(transferType.equals("subcompany")) {
				toname += SubCompanyComInfo.getSubCompanyname(_toid)+",";
			} else if(transferType.equals("role")) {
				toname += RolesComInfo.getRolesRemark(_toid)+",";
			} else if(transferType.equals("role")) {
				toname += JobTitlesComInfo.getJobtitleremark(_toid)+",";
			}
		}
		if(toname.endsWith(",")) {
			toname = toname.substring(0,toname.length()-1);
		}
	}
	String jsonSql = Tools.getURLDecode(request.getParameter("jsonSql"));
	MJson mjson = new MJson(jsonSql,true);
	HrmRightTransferManager transferManager = new HrmRightTransferManager(authorityTag, mjson, request).loadData();
	String[] codeNames = null;
	String[] lNames = null;
	String[] wTitles = null;
	String[] mTitles = null;
	String[] all = null;
	String[] idStr = null;
	int[] allNums = null;
	int[] num = null;
	out.println(transferManager.getFormInput());
	if(authorityTag.equals("transfer")){
		HrmRightTransfer bean = (HrmRightTransfer)transferManager.getBean();
%>
		<wea:layout type="2col">
			<wea:group context='<%=SystemEnv.getHtmlLabelNames("80,33368",user.getLanguage())%>'>
				<%
					if(transferType.equals("resource")){
						codeNames = new String[] {
							"T101","T111","T112","T113","T121","T122","T123","T124","T125","T131",
							"T132","T133","T134","T141","T142","T143","T144","T145","T146","T147",
							"T148","T149","T151","T152","T161","T171","T181","T182","T183","T191",
							"Temail001","Temail002"};
						allNums = new int[] {
							bean.getT101AllNum(),bean.getT111AllNum(),bean.getT112AllNum(),bean.getT113AllNum(),bean.getT121AllNum(),
							bean.getT122AllNum(),bean.getT123AllNum(),bean.getT124AllNum(),bean.getT125AllNum(),bean.getT131AllNum(),
							bean.getT132AllNum(),bean.getT133AllNum(),bean.getT134AllNum(),bean.getT141AllNum(),bean.getT142AllNum(),
							bean.getT143AllNum(),bean.getT144AllNum(),bean.getT145AllNum(),bean.getT146AllNum(),bean.getT147AllNum(),
							bean.getT148AllNum(),bean.getT149AllNum(),bean.getT151AllNum(),bean.getT152AllNum(),bean.getT161AllNum(),
							bean.getT171AllNum(),bean.getT181AllNum(),bean.getT182AllNum(),bean.getT183AllNum(),bean.getT191AllNum(),
							bean.getTemail001AllNum(),bean.getTemail002AllNum()};
						lNames = new String[] {
							"21313","33929,101","430,101","101,1332","442","122","22671","33646","33645","18015,15586,99",
							"15060,665,18015","1207","17991","58,21945","58,77,385","58,78,385","58,15059","20482,633,385","15060,60,16398","15060,60,25237",
							"58,79","20306,58","33929,2103","430,2103","2211","535","18831","17855,21945","17855,633,385","15060,60,33677"
							,"131756","131757"};
						mTitles = new String[] {
							"33372","33373","34001","34002","33374","34003","34004","34005","34006","34007",
							"34008","34009","34010","34011","34012","34013","34014","34015","34016","34017",
							"33375","34041","34018","34019","34020","34021","33377","34022","34023","34024",
							"131758","131759"};
						wTitles = new String[] {
							"172,21313","172,101","172,101","172,101,1332","172,442","172,122","172,124","172,33646","172,33645","172,18015,15586,15072",
							"172,665,18015","172,1207","172,17991","172,58,92","172,58,92","172,58,92","172,58,92","172,20482","172,65","172,66",
							"172,58","172,58","172,2103","172,2103","172,2211","172,535","172,18831","172,17855,34242","172,17855,34242","172,33677",
							"172,131756","172,131757"};
						all = new String[] {
							bean.getT101All(),bean.getT111All(),bean.getT112All(),bean.getT113All(),bean.getT121All(),
							bean.getT122All(),bean.getT123All(),bean.getT124All(),bean.getT125All(),bean.getT131All(),
							bean.getT132All(),bean.getT133All(),bean.getT134All(),bean.getT141All(),bean.getT142All(),
							bean.getT143All(),bean.getT144All(),bean.getT145All(),bean.getT146All(),bean.getT147All(),
							bean.getT148All(),bean.getT149All(),bean.getT151All(),bean.getT152All(),bean.getT161All(),
							bean.getT171All(),bean.getT181All(),bean.getT182All(),bean.getT183All(),bean.getT191All(),
							bean.getTemail001All(),bean.getTemail002All()};
						num = new int[] {
							bean.getT101Num(),bean.getT111Num(),bean.getT112Num(),bean.getT113Num(),bean.getT121Num(),
							bean.getT122Num(),bean.getT123Num(),bean.getT124Num(),bean.getT125Num(),bean.getT131Num(),
							bean.getT132Num(),bean.getT133Num(),bean.getT134Num(),bean.getT141Num(),bean.getT142Num(),
							bean.getT143Num(),bean.getT144Num(),bean.getT145Num(),bean.getT146Num(),bean.getT147Num(),
							bean.getT148Num(),bean.getT149Num(),bean.getT151Num(),bean.getT152Num(),bean.getT161Num(),
							bean.getT171Num(),bean.getT181Num(),bean.getT182Num(),bean.getT183Num(),bean.getT191Num(),
							bean.getTemail001Num(),bean.getTemail002Num()};
						idStr = new String[] {
							bean.getT101IdStr(),bean.getT111IdStr(),bean.getT112IdStr(),bean.getT113IdStr(),bean.getT121IdStr(),
							bean.getT122IdStr(),bean.getT123IdStr(),bean.getT124IdStr(),bean.getT125IdStr(),bean.getT131IdStr(),
							bean.getT132IdStr(),bean.getT133IdStr(),bean.getT134IdStr(),bean.getT141IdStr(),bean.getT142IdStr(),
							bean.getT143IdStr(),bean.getT144IdStr(),bean.getT145IdStr(),bean.getT146IdStr(),bean.getT147IdStr(),
							bean.getT148IdStr(),bean.getT149IdStr(),bean.getT151IdStr(),bean.getT152IdStr(),bean.getT161IdStr(),
							bean.getT171IdStr(),bean.getT181IdStr(),bean.getT182IdStr(),bean.getT183IdStr(),bean.getT191IdStr(),
							bean.getTemail001IdStr(),bean.getTemail002IdStr()};
					} else if(transferType.equals("department")){
						codeNames = new String[] {
							"T201","T202","T203","T204","T211","T221","T222","T223","T224","T225",
							"T226","T231","T232","T241"};
						allNums = new int[] {
							bean.getT201AllNum(),bean.getT202AllNum(),bean.getT203AllNum(),bean.getT204AllNum(),bean.getT211AllNum(),
							bean.getT221AllNum(),bean.getT222AllNum(),bean.getT223AllNum(),bean.getT224AllNum(),bean.getT225AllNum(),
							bean.getT226AllNum(),bean.getT231AllNum(),bean.getT232AllNum(),bean.getT241AllNum()};
						lNames = new String[] {
							"17587","6086","179","24002","18015,15586,99","58,21945","58,77,385","58,78,385","58,15059","15060,60,16398",
							"15060,60,25237","17855,21945","17855,633,385","15060,60,33677"};
						mTitles = new String[] {
							"34025","34026","34027","34028","34007","34011","34012","34013","34014","34016",
							"34017","34022","34023","34024"};
						wTitles = new String[] {
							"172,124","172,6086","172,179","172,24002","172,18015,15586,15072","172,58,92","172,58,92","172,58,92","172,58,92","34016 172,65",
							"34017 172,66","172,17855,34242","172,17855,34242","172,33677"};
						all = new String[] {
							bean.getT201All(),bean.getT202All(),bean.getT203All(),bean.getT204All(),bean.getT211All(),
							bean.getT221All(),bean.getT222All(),bean.getT223All(),bean.getT224All(),bean.getT225All(),
							bean.getT226All(),bean.getT231All(),bean.getT232All(),bean.getT241All()};
						num = new int[] {
							bean.getT201Num(),bean.getT202Num(),bean.getT203Num(),bean.getT204Num(),bean.getT211Num(),
							bean.getT221Num(),bean.getT222Num(),bean.getT223Num(),bean.getT224Num(),bean.getT225Num(),
							bean.getT226Num(),bean.getT231Num(),bean.getT232Num(),bean.getT241Num()};
						idStr = new String[] {
							bean.getT201IdStr(),bean.getT202IdStr(),bean.getT203IdStr(),bean.getT204IdStr(),bean.getT211IdStr(),
							bean.getT221IdStr(),bean.getT222IdStr(),bean.getT223IdStr(),bean.getT224IdStr(),bean.getT225IdStr(),
							bean.getT226IdStr(),bean.getT231IdStr(),bean.getT232IdStr(),bean.getT241IdStr()};
					} else if(transferType.equals("subcompany")){
						codeNames = new String[] {
							"T301","T302","T303","T311","T321","T322",
							"T323","T324","T325","T326","T331","T332","T341"};
						allNums = new int[] {
							bean.getT301AllNum(),bean.getT302AllNum(),bean.getT303AllNum(),bean.getT311AllNum(),bean.getT321AllNum(),
							bean.getT322AllNum(),bean.getT323AllNum(),bean.getT324AllNum(),bean.getT325AllNum(),bean.getT326AllNum(),
							bean.getT331AllNum(),bean.getT332AllNum(),bean.getT341AllNum()};
						lNames = new String[] {
							"17898","124","24002","18015,15586,99","58,21945","58,77,385",
							"58,78,385","58,15059","15060,60,16398","15060,60,25237","17855,21945","17855,633,385","15060,60,33677"};
						mTitles = new String[] {
							"34029","34030","34028","34007","34011","34012",
							"34013","34014","34016","34017","34022","34023","34024"};
						wTitles = new String[] {
							"172,141","172,124","172,24002","172,18015,15586,15072","172,58,92","172,58,92",
							"172,58,92","172,58,92","34016 172,65","34017 172,66","172,17855,34242","172,17855,34242","172,33677"};
						all = new String[] {
							bean.getT301All(),bean.getT302All(),bean.getT303All(),bean.getT311All(),bean.getT321All(),
							bean.getT322All(),bean.getT323All(),bean.getT324All(),bean.getT325All(),bean.getT326All(),
							bean.getT331All(),bean.getT332All(),bean.getT341All()};
						num = new int[] {
							bean.getT301Num(),bean.getT302Num(),bean.getT303Num(),bean.getT311Num(),bean.getT321Num(),
							bean.getT322Num(),bean.getT323Num(),bean.getT324Num(),bean.getT325Num(),bean.getT326Num(),
							bean.getT331Num(),bean.getT332Num(),bean.getT341Num()};
						idStr = new String[] {
							bean.getT301IdStr(),bean.getT302IdStr(),bean.getT303IdStr(),bean.getT311IdStr(),bean.getT321IdStr(),
							bean.getT322IdStr(),bean.getT323IdStr(),bean.getT324IdStr(),bean.getT325IdStr(),bean.getT326IdStr(),
							bean.getT331IdStr(),bean.getT332IdStr(),bean.getT341IdStr()};
					} else if(transferType.equals("role")){
						codeNames = new String[] {
							"T401","T411","T412",
							"T413","T414","T415","T416","T421","T422","T431"};
						allNums = new int[] {
							bean.getT401AllNum(),bean.getT411AllNum(),bean.getT412AllNum(),bean.getT413AllNum(),
							bean.getT414AllNum(),bean.getT415AllNum(),bean.getT416AllNum(),bean.getT421AllNum(),
							bean.getT422AllNum(),bean.getT431AllNum()};
						lNames = new String[] {
							"18015,15586,99","58,21945","58,77,385",
							"58,78,385","58,15059","15060,60,16398","15060,60,25237","17855,21945","17855,633,385","15060,60,33677"};
						mTitles = new String[] {
							"34007","34011","34012",
							"34013","34014","34016","34017","34022","34023","34024"};
						wTitles = new String[] {
							"172,18015,15586,15072","172,58,92","172,58,92",
							"172,58,92","172,58,92","34016 172,65","34017 172,66","172,17855,34242","172,17855,34242","172,33677"};
						all = new String[] {
							bean.getT401All(),bean.getT411All(),bean.getT412All(),bean.getT413All(),
							bean.getT414All(),bean.getT415All(),bean.getT416All(),bean.getT421All(),
							bean.getT422All(),bean.getT431All()};
						num = new int[] {
							bean.getT401Num(),bean.getT411Num(),bean.getT412Num(),bean.getT413Num(),
							bean.getT414Num(),bean.getT415Num(),bean.getT416Num(),bean.getT421Num(),
							bean.getT422Num(),bean.getT431Num()};
						idStr = new String[] {
							bean.getT401IdStr(),bean.getT411IdStr(),bean.getT412IdStr(),bean.getT413IdStr(),
							bean.getT414IdStr(),bean.getT415IdStr(),bean.getT416IdStr(),bean.getT421IdStr(),
							bean.getT422IdStr(),bean.getT431IdStr()};
					} else if(transferType.equals("jobtitle")){
							codeNames = new String[] {
								"T501","T511","T521","T522","T523","T524","T525","T531","T532","T541"};
							allNums = new int[] {
								bean.getT501AllNum(),bean.getT511AllNum(),bean.getT522AllNum(),bean.getT523AllNum(),
								bean.getT524AllNum(),bean.getT524AllNum(),bean.getT525AllNum(),bean.getT531AllNum(),
								bean.getT532AllNum(),bean.getT541AllNum()};
							lNames = new String[] {
								"179","18015,15586,99","58,21945","58,77,385",
								"58,78,385","58,15059","15060,60,16398","17855,21945","17855,633,385","15060,60,33677"};
							mTitles = new String[] {
								"126746","34007","34011","34012",
								"34013","34014","34016","34022","34023","34024"};
							wTitles = new String[] {
								"172,179","172,18015,15586,15072","172,58,92","172,58,92",
								"172,58,92","172,58,92","34016,172,65","172,17855,34242","172,17855,34242","172,33677"};
							all = new String[] {
								bean.getT501All(),bean.getT511All(),bean.getT521All(),bean.getT522All(),
								bean.getT523All(),bean.getT524All(),bean.getT525All(),bean.getT531All(),
								bean.getT532All(),bean.getT541All()};
							num = new int[] {
								bean.getT501Num(),bean.getT511Num(),bean.getT521Num(),bean.getT522Num(),
								bean.getT523Num(),bean.getT524Num(),bean.getT525Num(),bean.getT531Num(),
								bean.getT532Num(),bean.getT541Num()};
							idStr = new String[] {
								bean.getT501IdStr(),bean.getT511IdStr(),bean.getT521IdStr(),bean.getT522IdStr(),
								bean.getT523IdStr(),bean.getT524IdStr(),bean.getT525IdStr(),bean.getT531IdStr(),
								bean.getT532IdStr(),bean.getT541IdStr()};
						}
					if(allNums != null){
						String[] delCodes = {"T147", "T226", "T326", "T416","T202"};
						for(int i=0; i<allNums.length; i++){
							boolean isContinue = false;
							for(int j=0; j<delCodes.length; j++){
								if(codeNames[i].equals(delCodes[j])){
									isContinue = true;
									break;
								}
							}
							if(isContinue) continue;
							if(codeNames[i].equals("T203")){
%>
							<wea:item attributes="{'samePair':'T203'}"><%=SystemEnv.getHtmlLabelNames(lNames[i],user.getLanguage())%></wea:item>
							<wea:item attributes="{'samePair':'T203'}">
								<table width="100%">
								<tr>
									<td width="15%">
										<input type="checkbox" name="T203All" value=1 <%if(all[i].equals("1")||(num[i]==allNums[i])){%> checked <%}%> onClick="checkboxSelect('true','',0,'<%=allNums[i]%>','T203Num','T203All','T203IdStr')">&nbsp;&nbsp;<%=SystemEnv.getHtmlLabelName(332,user.getLanguage())%><input class=inputstyle type=hidden name="T203AllNum" value="<%=allNums[i]%>">
									</td>
									<td width="5%"><button type=button class=Browser onClick="openWindow('<%=Tools.vString(bean.getAddressMap().get(codeNames[i]))%>','<%=SystemEnv.getHtmlLabelNames(wTitles[i],user.getLanguage())%>','<%=allNums[i]%>','T203Num','T203All','T203IdStr')"></button></td>
									<td width="5%"><%=SystemEnv.getHtmlLabelName(31503,user.getLanguage())%></td>
									<td width="5%"><span id="T203Num" style="<%=num[i] > 0 ? "color:#1E90FF" : ""%>"><%=num[i]%></span></td>
									<td width="5%">,&nbsp;&nbsp;<%=SystemEnv.getHtmlLabelName(523,user.getLanguage())%> </td>
									<td width="5%"><span id="init_T203AllNum"><%=allNums[i]%></span></td>
									<td width="55%"><img src="/wechat/images/remind_wev8.png" align="absMiddle" title="<%=Tools.replace(SystemEnv.getHtmlLabelNames(mTitles[i],user.getLanguage()),"{param}"," "+fromname+" ")%>" /></td>
								</tr>
								</table>
							</wea:item>
<%								
							} else {
								if(allNums[i] <= 0) continue;
%>					
							<wea:item><%=SystemEnv.getHtmlLabelNames(lNames[i],user.getLanguage())%></wea:item>
							<wea:item><%=transferManager.getContentCode(codeNames[i], Tools.vString(bean.getAddressMap().get(codeNames[i])), SystemEnv.getHtmlLabelNames(wTitles[i],user.getLanguage()), Tools.replace(SystemEnv.getHtmlLabelNames(mTitles[i],user.getLanguage()),"{param}"," "+fromname+" "), allNums[i], all[i], num[i], idStr[i])%></wea:item>
<%
							}
						}
					}
				%>
			</wea:group>
		</wea:layout>
<%
	} else if(authorityTag.equals("copy")){
		HrmRightCopy bean = (HrmRightCopy)transferManager.getBean();
%>
		<wea:layout type="2col">
			<wea:group context='<%=SystemEnv.getHtmlLabelNames("77,33368",user.getLanguage())%>'>
				<%
					if(transferType.equals("resource")){
						codeNames = new String[] {
							"C101","C111","C112","C121","C122","C123","C131","C132","C133","C141",
							"C142","C143","C144","C145","C146","C147","C148","C151","C161","C171",
							"C172","C173","C181"};
						allNums = new int[] {
							bean.getC101AllNum(),bean.getC111AllNum(),bean.getC112AllNum(),bean.getC121AllNum(),bean.getC122AllNum(),
							bean.getC123AllNum(),bean.getC131AllNum(),bean.getC132AllNum(),bean.getC133AllNum(),bean.getC141AllNum(),
							bean.getC142AllNum(),bean.getC143AllNum(),bean.getC144AllNum(),bean.getC145AllNum(),bean.getC146AllNum(),
							bean.getC147AllNum(),bean.getC148AllNum(),bean.getC151AllNum(),bean.getC161AllNum(),bean.getC171AllNum(),
							bean.getC172AllNum(),bean.getC173AllNum(),bean.getC181AllNum()};
						lNames = new String[] {
							"20306,21313","430,101","20306,101","122","33646","33645","31698,385","15060,665,18015","17991","58,21945",
							"58,77,385","58,78,385","58,15059","20482,633,385","15060,60,16398","15060,60,25237","20306,58","430,2103","2211","430,17855",
							"17694,21945","17694,633,385","15060,60,33677"};
						mTitles = new String[] {
							"34039","34001","34040","34003","34005","34006","34044","34008","34010","34011",
							"34012","34013","34014","34015","34016","34017","34041","34019","34020","34046",
							"34022","34023","34024"};
						wTitles = new String[] {
							"172,21313","172,101","172,101","172,122","172,33646","172,33645","172,31698,385","172,665,18015","172,17991","172,58,92",
							"172,58,92","172,58,92","172,58,92","172,20482","172,65","172,66","172,58","172,2103","172,2211","172,17855,344",
							"172,17694,21945","172,17694,633,385","172,33677"};
						all = new String[] {
							bean.getC101All(),bean.getC111All(),bean.getC112All(),bean.getC121All(),bean.getC122All(),
							bean.getC123All(),bean.getC131All(),bean.getC132All(),bean.getC133All(),bean.getC141All(),
							bean.getC142All(),bean.getC143All(),bean.getC144All(),bean.getC145All(),bean.getC146All(),
							bean.getC147All(),bean.getC148All(),bean.getC151All(),bean.getC161All(),bean.getC171All(),
							bean.getC172All(),bean.getC173All(),bean.getC181All()};
						num = new int[] {
							bean.getC101Num(),bean.getC111Num(),bean.getC112Num(),bean.getC121Num(),bean.getC122Num(),
							bean.getC123Num(),bean.getC131Num(),bean.getC132Num(),bean.getC133Num(),bean.getC141Num(),
							bean.getC142Num(),bean.getC143Num(),bean.getC144Num(),bean.getC145Num(),bean.getC146Num(),
							bean.getC147Num(),bean.getC148Num(),bean.getC151Num(),bean.getC161Num(),bean.getC171Num(),
							bean.getC172Num(),bean.getC173Num(),bean.getC181Num()};
						idStr = new String[] {
							bean.getC101IdStr(),bean.getC111IdStr(),bean.getC112IdStr(),bean.getC121IdStr(),bean.getC122IdStr(),
							bean.getC123IdStr(),bean.getC131IdStr(),bean.getC132IdStr(),bean.getC133IdStr(),bean.getC141IdStr(),
							bean.getC142IdStr(),bean.getC143IdStr(),bean.getC144IdStr(),bean.getC145IdStr(),bean.getC146IdStr(),
							bean.getC147IdStr(),bean.getC148IdStr(),bean.getC151IdStr(),bean.getC161IdStr(),bean.getC171IdStr(),
							bean.getC172IdStr(),bean.getC173IdStr(),bean.getC181IdStr()};
					} else if(transferType.equals("department")){
						codeNames = new String[] {
							"C201","C202","C211","C221","C231","C241","C242",
							"C243","C244","C245","C246","C247","C251","C252","C261"};
						allNums = new int[] {
							bean.getC201AllNum(),bean.getC202AllNum(),bean.getC211AllNum(),bean.getC221AllNum(),bean.getC231AllNum(),
							bean.getC241AllNum(),bean.getC242AllNum(),bean.getC243AllNum(),bean.getC244AllNum(),bean.getC245AllNum(),
							bean.getC246AllNum(),bean.getC247AllNum(),bean.getC251AllNum(),bean.getC252AllNum(),bean.getC261AllNum()};
						lNames = new String[] {
							"6086","24002","20306,21313","20306,101","31698,385","58,21945","58,77,385",
							"58,78,385","58,15059","15060,60,16398","15060,60,25237","20306,58","17694,21945","17694,633,385","15060,60,33677"};
						mTitles = new String[] {
							"34026","34028","34039","34040","34044","34011","34012",
							"34013","34014","34016","34017","34041","34022","34023","34024"};
						wTitles = new String[] {
							"172,6086","172,24002","172,21313","172,101","172,31698,385","172,58,92","172,58,92",
							"172,58,92","172,58,92","172,65","172,66","172,58","172,17694,21945","172,17694,633,385","172,33677"};
						all = new String[] {
							bean.getC201All(),bean.getC202All(),bean.getC211All(),bean.getC221All(),bean.getC231All(),
							bean.getC241All(),bean.getC242All(),bean.getC243All(),bean.getC244All(),bean.getC245All(),
							bean.getC246All(),bean.getC247All(),bean.getC251All(),bean.getC252All(),bean.getC261All()};
						num = new int[] {
							bean.getC201Num(),bean.getC202Num(),bean.getC211Num(),bean.getC221Num(),bean.getC231Num(),
							bean.getC241Num(),bean.getC242Num(),bean.getC243Num(),bean.getC244Num(),bean.getC245Num(),
							bean.getC246Num(),bean.getC247Num(),bean.getC251Num(),bean.getC252Num(),bean.getC261Num()};
						idStr = new String[] {
							bean.getC201IdStr(),bean.getC202IdStr(),bean.getC211IdStr(),bean.getC221IdStr(),bean.getC231IdStr(),
							bean.getC241IdStr(),bean.getC242IdStr(),bean.getC243IdStr(),bean.getC244IdStr(),bean.getC245IdStr(),
							bean.getC246IdStr(),bean.getC247IdStr(),bean.getC251IdStr(),bean.getC252IdStr(),bean.getC261IdStr()};
					} else if(transferType.equals("subcompany")){
						codeNames = new String[] {
							"C301","C302",
							"C303","C311","C321","C331","C341","C342","C343","C344","C345","C346",
							"C347","C351","C352","C361"};
						allNums = new int[] {
							bean.getC301AllNum(),bean.getC302AllNum(),bean.getC303AllNum(),bean.getC311AllNum(),bean.getC321AllNum(),
							bean.getC331AllNum(),bean.getC341AllNum(),bean.getC342AllNum(),bean.getC343AllNum(),bean.getC344AllNum(),
							bean.getC345AllNum(),bean.getC346AllNum(),bean.getC347AllNum(),bean.getC351AllNum(),bean.getC352AllNum(),
							bean.getC361AllNum()};
						lNames = new String[] {
							"124","6086",
							"24002","20306,21313","20306,101","31698,385","58,21945","58,77,385","58,78,385","58,15059","15060,60,16398","15060,60,25237",
							"20306,58","17694,21945","17694,633,385","15060,60,33677"};
						mTitles = new String[] {
							"34030","34042",
							"34028","34039","34040","34044","34011","34012","34013","34014","34016","34017",
							"34041","34022","34023","34024"};
						wTitles = new String[] {
							"172,124","172,6086",
							"172,24002","172,21313","172,101","172,31698,385","172,58,92","172,58,92","172,58,92","172,58,92","172,65","172,66",
							"172,58","172,17694,21945","172,17694,633,385","172,33677"};
						all = new String[] {
							bean.getC301All(),bean.getC302All(),bean.getC303All(),bean.getC311All(),bean.getC321All(),
							bean.getC331All(),bean.getC341All(),bean.getC342All(),bean.getC343All(),bean.getC344All(),
							bean.getC345All(),bean.getC346All(),bean.getC347All(),bean.getC351All(),bean.getC352All(),
							bean.getC361All()};
						num = new int[] {
							bean.getC301Num(),bean.getC302Num(),bean.getC303Num(),bean.getC311Num(),bean.getC321Num(),
							bean.getC331Num(),bean.getC341Num(),bean.getC342Num(),bean.getC343Num(),bean.getC344Num(),
							bean.getC345Num(),bean.getC346Num(),bean.getC347Num(),bean.getC351Num(),bean.getC352Num(),
							bean.getC361Num()};
						idStr = new String[] {
							bean.getC301IdStr(),bean.getC302IdStr(),bean.getC303IdStr(),bean.getC311IdStr(),bean.getC321IdStr(),
							bean.getC331IdStr(),bean.getC341IdStr(),bean.getC342IdStr(),bean.getC343IdStr(),bean.getC344IdStr(),
							bean.getC345IdStr(),bean.getC346IdStr(),bean.getC347IdStr(),bean.getC351IdStr(),bean.getC352IdStr(),
							bean.getC361IdStr()};
					} else if(transferType.equals("role")){
						codeNames = new String[] {
							"C401","C411","C421","C431","C432","C433",
							"C434","C435","C436","C437","C441","C442","C451"};
						allNums = new int[] {
							bean.getC401AllNum(),bean.getC411AllNum(),bean.getC421AllNum(),bean.getC431AllNum(),
							bean.getC432AllNum(),bean.getC433AllNum(),bean.getC434AllNum(),bean.getC435AllNum(),
							bean.getC436AllNum(),bean.getC437AllNum(),bean.getC441AllNum(),bean.getC442AllNum(),
							bean.getC451AllNum()};
						lNames = new String[] {
							"20306,21313","20306,101","31698,385","58,21945","58,77,385","58,78,385",
							"58,15059","15060,60,16398","15060,60,25237","20306,58","17694,21945","17694,633,385","15060,60,33677"};
						mTitles = new String[] {
							"34039","34040","34044","34011","34012","34013",
							"34014","34016","34017","34041","34022","34023","34024"};
						wTitles = new String[] {
							"172,21313","172,101","172,31698,385","172,58,92","172,58,92","172,58,92",
							"172,58,92","172,65","172,66","172,58","172,17694,21945","172,17694,633,385","172,33677"};
						all = new String[] {
							bean.getC401All(),bean.getC411All(),bean.getC421All(),bean.getC431All(),
							bean.getC432All(),bean.getC433All(),bean.getC434All(),bean.getC435All(),
							bean.getC436All(),bean.getC437All(),bean.getC441All(),bean.getC442All(),
							bean.getC451All()};
						num = new int[] {
							bean.getC401Num(),bean.getC411Num(),bean.getC421Num(),bean.getC431Num(),
							bean.getC432Num(),bean.getC433Num(),bean.getC434Num(),bean.getC435Num(),
							bean.getC436Num(),bean.getC437Num(),bean.getC441Num(),bean.getC442Num(),
							bean.getC451Num()};
						idStr = new String[] {
							bean.getC401IdStr(),bean.getC411IdStr(),bean.getC421IdStr(),bean.getC431IdStr(),
							bean.getC432IdStr(),bean.getC433IdStr(),bean.getC434IdStr(),bean.getC435IdStr(),
							bean.getC436IdStr(),bean.getC437IdStr(),bean.getC441IdStr(),bean.getC442IdStr(),
							bean.getC451IdStr()};
					} else if(transferType.equals("jobtitle")){
						codeNames = new String[] {
								"C501","C511","C521","C531","C532","C533","C534","C535",
								"C536","C541","C542","C551"};
							allNums = new int[] {
								bean.getC501AllNum(),bean.getC511AllNum(),bean.getC521AllNum(),bean.getC531AllNum(),
								bean.getC532AllNum(),bean.getC533AllNum(),bean.getC534AllNum(),bean.getC535AllNum(),
								bean.getC536AllNum(),bean.getC541AllNum(),bean.getC542AllNum(),
								bean.getC551AllNum()};
							lNames = new String[] {
								"20306,21313","20306,101","31698,385","58,21945","58,77,385","58,78,385",
								"58,15059","15060,60,16398","20306,58","17694,21945","17694,633,385","15060,60,33677"};
							mTitles = new String[] {
								"34039","34040","34044","34011","34012","34013",
								"34014","34016","34041","34022","34023","34024"};
							wTitles = new String[] {
								"172,21313","172,101","172,31698,385","172,58,92","172,58,92","172,58,92",
								"172,58,92","172,65","172,58","172,17694,21945","172,17694,633,385","172,33677"};
							all = new String[] {
								bean.getC501All(),bean.getC511All(),bean.getC521All(),bean.getC531All(),
								bean.getC532All(),bean.getC533All(),bean.getC534All(),bean.getC535All(),
								bean.getC536All(),bean.getC541All(),bean.getC542All(),
								bean.getC551All()};
							num = new int[] {
								bean.getC501Num(),bean.getC511Num(),bean.getC521Num(),bean.getC531Num(),
								bean.getC532Num(),bean.getC533Num(),bean.getC534Num(),bean.getC535Num(),
								bean.getC536Num(),bean.getC541Num(),bean.getC542Num(),
								bean.getC551Num()};
							idStr = new String[] {
								bean.getC501IdStr(),bean.getC511IdStr(),bean.getC521IdStr(),bean.getC531IdStr(),
								bean.getC532IdStr(),bean.getC533IdStr(),bean.getC534IdStr(),bean.getC535IdStr(),
								bean.getC536IdStr(),bean.getC541IdStr(),bean.getC542IdStr(),
								bean.getC551IdStr()};
						}
					if(allNums != null){
						String[] delCodes = {"C147", "C246", "C346", "C436","C201","C302"};
						for(int i=0; i<allNums.length; i++){
							boolean isContinue = false;
							for(int j=0; j<delCodes.length; j++){
								if(codeNames[i].equals(delCodes[j])){
									isContinue = true;
									break;
								}
							}
							if(isContinue) continue;
							if(codeNames[i].equals("C302")){
%>
							<wea:item attributes="{'samePair':'C302'}"><%=SystemEnv.getHtmlLabelNames(lNames[i],user.getLanguage())%></wea:item>
							<wea:item attributes="{'samePair':'C302'}">
								<table width="100%">
								<tr>
									<td width="15%">
										<input type="checkbox" name="C302All" value=1 <%if(all[i].equals("1")||(num[i]==allNums[i])){%> checked <%}%> onClick="checkboxSelect('true','',0,'<%=allNums[i]%>','C302Num','C302All','C302IdStr')">&nbsp;&nbsp;<%=SystemEnv.getHtmlLabelName(332,user.getLanguage())%><input class=inputstyle type=hidden name="C302AllNum" value="<%=allNums[i]%>">
									</td>
									<td width="5%"><button type=button class=Browser onClick="openWindow('<%=Tools.vString(bean.getAddressMap().get(codeNames[i]))%>','<%=SystemEnv.getHtmlLabelNames(wTitles[i],user.getLanguage())%>','<%=allNums[i]%>','C302Num','C302All','C302IdStr')"></button></td>
									<td width="5%"><%=SystemEnv.getHtmlLabelName(31503,user.getLanguage())%></td>
									<td width="5%"><span id="C302Num" style="<%=num[i] > 0 ? "color:#1E90FF" : ""%>"><%=num[i]%></span></td>
									<td width="5%">,&nbsp;&nbsp;<%=SystemEnv.getHtmlLabelName(523,user.getLanguage())%> </td>
									<td width="5%"><span id="init_C302AllNum"><%=allNums[i]%></span></td>
									<td width="55%"><img src="/wechat/images/remind_wev8.png" align="absMiddle" title="<%=Tools.replace(SystemEnv.getHtmlLabelNames(mTitles[i],user.getLanguage()),"{param}"," "+fromname+" ")%>" /></td>
								</tr>
								</table>
							</wea:item>
<%
							} else {
								if(allNums[i] <= 0) continue;
%>					
							<wea:item><%=SystemEnv.getHtmlLabelNames(lNames[i],user.getLanguage())%></wea:item>
							<wea:item><%=transferManager.getContentCode(codeNames[i], Tools.vString(bean.getAddressMap().get(codeNames[i])), SystemEnv.getHtmlLabelNames(wTitles[i],user.getLanguage()), Tools.replace(SystemEnv.getHtmlLabelNames(mTitles[i],user.getLanguage()),"{param}"," "+fromname+" "), allNums[i], all[i], num[i], idStr[i])%></wea:item>
<%
							}
						}
					}
				%>
			</wea:group>
		</wea:layout>
<%
	} else if(authorityTag.equals("delete")){
		HrmRightDelete bean = (HrmRightDelete)transferManager.getBean();
%>
		<wea:layout type="2col">
			<wea:group context='<%=SystemEnv.getHtmlLabelNames("91,33368",user.getLanguage())%>'>
				<%
					if(transferType.equals("resource")){
						codeNames = new String[] {
							"D102","D103","D104","D105","D111","D112","D113","D121","D122",
							"D123","D124","D125","D126","D127","D128","D131","D141","D151","D152",
							"D153","D161","D171","D181"};
						allNums = new int[] {
							bean.getD102AllNum(),bean.getD103AllNum(),bean.getD104AllNum(),bean.getD105AllNum(),
							bean.getD111AllNum(),bean.getD112AllNum(),bean.getD113AllNum(),bean.getD121AllNum(),bean.getD122AllNum(),
							bean.getD123AllNum(),bean.getD124AllNum(),bean.getD125AllNum(),bean.getD126AllNum(),bean.getD127AllNum(),
							bean.getD128AllNum(),bean.getD131AllNum(),bean.getD141AllNum(),bean.getD151AllNum(),bean.getD152AllNum(),
							bean.getD153AllNum(),bean.getD161AllNum(),bean.getD171AllNum(),bean.getD181AllNum()};
						lNames = new String[] {
							"122","22671","33646","33645","18015,15586,99","15060,665,18015","31698,385","58,21945","58,77,385",
							"58,78,385","58,15059","20482,633,385","15060,60,16398","15060,60,25237","20306,58","430,2103","2211","17855,21945","17855,633,385",
							"430,17855","15060,60,33677","20306,21313","20306,101"};
						mTitles = new String[] {
							"34003","34004","34005","34006","34007","34008","34044","34011","34012",
							"34013","34014","34015","34016","34017","34041","34019","34020","34022","34023",
							"34046","33677","34039","34040"};
						wTitles = new String[] {
							"172,122","172,22671","172,33646","172,33645","172,18015,15586,15072","172,665,18015","172,18499","172,58,92","172,58,92",
							"172,58,92","172,58,92","172,20482","172,65","172,66","172,58","172,2103","172,2211","172,17855,34242","172,17855,34242",
							"172,17855,344","172,33677","172,21313","172,101"};
						all = new String[] {
							bean.getD102All(),bean.getD103All(),bean.getD104All(),bean.getD105All(),
							bean.getD111All(),bean.getD112All(),bean.getD113All(),bean.getD121All(),bean.getD122All(),
							bean.getD123All(),bean.getD124All(),bean.getD125All(),bean.getD126All(),bean.getD127All(),
							bean.getD128All(),bean.getD131All(),bean.getD141All(),bean.getD151All(),bean.getD152All(),
							bean.getD153All(),bean.getD161All(),bean.getD171All(),bean.getD181All()};
						num = new int[] {
							bean.getD102Num(),bean.getD103Num(),bean.getD104Num(),bean.getD105Num(),
							bean.getD111Num(),bean.getD112Num(),bean.getD113Num(),bean.getD121Num(),bean.getD122Num(),
							bean.getD123Num(),bean.getD124Num(),bean.getD125Num(),bean.getD126Num(),bean.getD127Num(),
							bean.getD128Num(),bean.getD131Num(),bean.getD141Num(),bean.getD151Num(),bean.getD152Num(),
							bean.getD153Num(),bean.getD161Num(),bean.getD171Num(),bean.getD181Num()};
						idStr = new String[] {
							bean.getD102IdStr(),bean.getD103IdStr(),bean.getD104IdStr(),bean.getD105IdStr(),
							bean.getD111IdStr(),bean.getD112IdStr(),bean.getD113IdStr(),bean.getD121IdStr(),bean.getD122IdStr(),
							bean.getD123IdStr(),bean.getD124IdStr(),bean.getD125IdStr(),bean.getD126IdStr(),bean.getD127IdStr(),
							bean.getD128IdStr(),bean.getD131IdStr(),bean.getD141IdStr(),bean.getD151IdStr(),bean.getD152IdStr(),
							bean.getD153IdStr(),bean.getD161IdStr(),bean.getD171IdStr(),bean.getD181IdStr()};
					} else if(transferType.equals("department")){
						codeNames = new String[] {
							"D201","D211","D212","D221","D222","D223",
							"D224","D225","D226","D227","D231","D232","D241","D251","D261"};
						allNums = new int[] {
							bean.getD201AllNum(),bean.getD211AllNum(),bean.getD212AllNum(),bean.getD221AllNum(),bean.getD222AllNum(),
							bean.getD223AllNum(),bean.getD224AllNum(),bean.getD225AllNum(),bean.getD226AllNum(),bean.getD227AllNum(),
							bean.getD231AllNum(),bean.getD232AllNum(),bean.getD241AllNum(),bean.getD251AllNum(),bean.getD261AllNum()};
						lNames = new String[] {
							"24002","18015,15586,99","31698,385","58,21945","58,77,385","58,78,385",
							"58,15059","15060,60,16398","15060,60,25237","20306,58","17855,21945","17855,633,385","15060,60,33677","20306,21313","20306,101"};
						mTitles = new String[] {
							"34028","34007","34044","34011","34012","34013",
							"34014","34016","34017","34041","34022","34023","34023","34039","34040"};
						wTitles = new String[] {
							"172,24002","172,18015,15586,15072","172,18499","172,58,92","172,58,92","172,58,92",
							"172,58,92","172,65","172,66","172,58","172,17855,34242","172,17855,34242","172,33677","172,21313","172,101"};
						all = new String[] {
							bean.getD201All(),bean.getD211All(),bean.getD212All(),bean.getD221All(),bean.getD222All(),
							bean.getD223All(),bean.getD224All(),bean.getD225All(),bean.getD226All(),bean.getD227All(),
							bean.getD231All(),bean.getD232All(),bean.getD241All(),bean.getD251All(),bean.getD261All()};
						num = new int[] {
							bean.getD201Num(),bean.getD211Num(),bean.getD212Num(),bean.getD221Num(),bean.getD222Num(),
							bean.getD223Num(),bean.getD224Num(),bean.getD225Num(),bean.getD226Num(),bean.getD227Num(),
							bean.getD231Num(),bean.getD232Num(),bean.getD241Num(),bean.getD251Num(),bean.getD261Num()};
						idStr = new String[] {
							bean.getD201IdStr(),bean.getD211IdStr(),bean.getD212IdStr(),bean.getD221IdStr(),bean.getD222IdStr(),
							bean.getD223IdStr(),bean.getD224IdStr(),bean.getD225IdStr(),bean.getD226IdStr(),bean.getD227IdStr(),
							bean.getD231IdStr(),bean.getD232IdStr(),bean.getD241IdStr(),bean.getD251IdStr(),bean.getD261IdStr()};
					} else if(transferType.equals("subcompany")){
						codeNames = new String[] {
							"D301",
							"D311","D312","D321","D322","D323","D324","D325","D326","D327","D331",
							"D332","D341","D351","D361"};
						allNums = new int[] {
							bean.getD301AllNum(),bean.getD311AllNum(),bean.getD312AllNum(),bean.getD321AllNum(),bean.getD322AllNum(),
							bean.getD323AllNum(),bean.getD324AllNum(),bean.getD325AllNum(),bean.getD326AllNum(),bean.getD327AllNum(),
							bean.getD331AllNum(),bean.getD332AllNum(),bean.getD341AllNum(),bean.getD351AllNum(),bean.getD361AllNum()};
						lNames = new String[] {
							"24002","18015,15586,99","31698,385","58,21945","58,77,385","58,78,385",
							"58,15059","15060,60,16398","15060,60,25237","20306,58","17855,21945","17855,633,385","15060,60,33677","20306,21313","20306,101"};
						mTitles = new String[] {
							"34028","34007","34044","34011","34012","34013",
							"34014","34016","34017","34041","34022","34023","34023","34039","34040"};
						wTitles = new String[] {
							"172,24002","172,18015,15586,15072","172,18499","172,58,92","172,58,92","172,58,92",
							"172,58,92","172,65","172,66","172,58","172,17855,34242","172,17855,34242","172,33677","172,21313","172,101"};
						all = new String[] {
							bean.getD301All(),bean.getD311All(),bean.getD312All(),bean.getD321All(),bean.getD322All(),
							bean.getD323All(),bean.getD324All(),bean.getD325All(),bean.getD326All(),bean.getD327All(),
							bean.getD331All(),bean.getD332All(),bean.getD341All(),bean.getD351All(),bean.getD361All()};
						num = new int[] {
							bean.getD301Num(),bean.getD311Num(),bean.getD312Num(),bean.getD321Num(),bean.getD322Num(),
							bean.getD323Num(),bean.getD324Num(),bean.getD325Num(),bean.getD326Num(),bean.getD327Num(),
							bean.getD331Num(),bean.getD332Num(),bean.getD341Num(),bean.getD351Num(),bean.getD361Num()};
						idStr = new String[] {
							bean.getD301IdStr(),bean.getD311IdStr(),bean.getD312IdStr(),bean.getD321IdStr(),bean.getD322IdStr(),
							bean.getD323IdStr(),bean.getD324IdStr(),bean.getD325IdStr(),bean.getD326IdStr(),bean.getD327IdStr(),
							bean.getD331IdStr(),bean.getD332IdStr(),bean.getD341IdStr(),bean.getD351IdStr(),bean.getD361IdStr()};
					} else if(transferType.equals("role")){
						codeNames = new String[] {
							"D401","D402","D411","D412","D413","D414",
							"D415","D416","D417","D421","D422","D431","D441","D451"};
						allNums = new int[] {
							bean.getD401AllNum(),bean.getD402AllNum(),bean.getD411AllNum(),bean.getD412AllNum(),bean.getD413AllNum(),
							bean.getD414AllNum(),bean.getD415AllNum(),bean.getD416AllNum(),bean.getD417AllNum(),bean.getD421AllNum(),
							bean.getD422AllNum(),bean.getD431AllNum(),bean.getD441AllNum(),bean.getD451AllNum()};
						lNames = new String[] {
							"18015,15586,99","31698,385","58,21945","58,77,385","58,78,385","58,15059",
							"15060,60,16398","15060,60,25237","20306,58","17855,21945","17855,633,385","15060,60,33677","20306,21313","20306,101"};
						mTitles = new String[] {
							"34007","34044","34011","34012","34013","34014",
							"34016","34017","34041","34022","34023","34023","34039","34040"};
						wTitles = new String[] {
							"172,18015,15586,15072","172,18499","172,58,92","172,58,92","172,58,92","172,58,92",
							"172,65","172,66","172,58","172,17855,34242","172,17855,34242","172,33677","172,21313","172,101"};
						all = new String[] {
							bean.getD401All(),bean.getD402All(),bean.getD411All(),bean.getD412All(),bean.getD413All(),
							bean.getD414All(),bean.getD415All(),bean.getD416All(),bean.getD417All(),bean.getD421All(),
							bean.getD422All(),bean.getD431All(),bean.getD441All(),bean.getD451All()};
						num = new int[] {
							bean.getD401Num(),bean.getD402Num(),bean.getD411Num(),bean.getD412Num(),bean.getD413Num(),
							bean.getD414Num(),bean.getD415Num(),bean.getD416Num(),bean.getD417Num(),bean.getD421Num(),
							bean.getD422Num(),bean.getD431Num(),bean.getD441Num(),bean.getD451Num()};
						idStr = new String[] {
							bean.getD401IdStr(),bean.getD402IdStr(),bean.getD411IdStr(),bean.getD412IdStr(),bean.getD413IdStr(),
							bean.getD414IdStr(),bean.getD415IdStr(),bean.getD416IdStr(),bean.getD417IdStr(),bean.getD421IdStr(),
							bean.getD422IdStr(),bean.getD431IdStr(),bean.getD441IdStr(),bean.getD451IdStr()};
					}else if(transferType.equals("jobtitle")){
						codeNames = new String[] {
							"D501","D511","D521","D522","D531","D532",
							"D533","D534","D535","D536","D541","D542","D551"};
						allNums = new int[] {
							bean.getD501AllNum(),bean.getD511AllNum(),bean.getD521AllNum(),bean.getD522AllNum(),bean.getD531AllNum(),
							bean.getD532AllNum(),bean.getD533AllNum(),bean.getD534AllNum(),bean.getD535AllNum(),bean.getD536AllNum(),
							bean.getD541AllNum(),bean.getD542AllNum(),bean.getD551AllNum()};
						lNames = new String[] {
								"20306,21313","20306,101","18015,15586,99","31698,385","58,21945","58,77,385","58,78,385",
								"58,15059","15060,60,16398","20306,58","17694,21945","17694,633,385","15060,60,33677"};
						mTitles = new String[] {
								"34039","34001","34007","34044","34011","34012","34013",
								"34014","34016","34041","34022","34023","34024"};
						wTitles = new String[] {
								"172,21313","172,101","172,18015,15586,15072","172,31698,385","172,58,92","172,58,92",
								"172,58,92","172,58,92","172,65","172,58","172,17694,21945","172,17694,633,385","172,33677"};
						all = new String[] {
							bean.getD501All(),bean.getD511All(),bean.getD521All(),bean.getD522All(),bean.getD531All(),
							bean.getD532All(),bean.getD533All(),bean.getD534All(),bean.getD535All(),bean.getD536All(),
							bean.getD541All(),bean.getD542All(),bean.getD551All()};
						num = new int[] {
							bean.getD501Num(),bean.getD511Num(),bean.getD521Num(),bean.getD522Num(),bean.getD531Num(),
							bean.getD532Num(),bean.getD533Num(),bean.getD534Num(),bean.getD535Num(),bean.getD536Num(),
							bean.getD541Num(),bean.getD542Num(),bean.getD551Num()};
						idStr = new String[] {
							bean.getD501IdStr(),bean.getD511IdStr(),bean.getD521IdStr(),bean.getD522IdStr(),bean.getD531IdStr(),
							bean.getD532IdStr(),bean.getD533IdStr(),bean.getD534IdStr(),bean.getD535IdStr(),bean.getD536IdStr(),
							bean.getD541IdStr(),bean.getD542IdStr(),bean.getD551IdStr()};
					}
					if(allNums != null){
						String[] delCodes = {"D127", "D226", "D326", "D416"};
						for(int i=0; i<allNums.length; i++){
							boolean isContinue = false;
							for(int j=0; j<delCodes.length; j++){
								if(codeNames[i].equals(delCodes[j])){
									isContinue = true;
									break;
								}
							}
							if(isContinue || allNums[i] <= 0) continue;
%>					
							<wea:item><%=SystemEnv.getHtmlLabelNames(lNames[i],user.getLanguage())%></wea:item>
							<wea:item><%=transferManager.getContentCode(codeNames[i], Tools.vString(bean.getAddressMap().get(codeNames[i])), SystemEnv.getHtmlLabelNames(wTitles[i],user.getLanguage()), Tools.replace(SystemEnv.getHtmlLabelNames(mTitles[i],user.getLanguage()),"{param}"," "+fromname+" "), allNums[i], all[i], num[i], idStr[i])%></wea:item>
<%
						}
					}
				%>
			</wea:group>
		</wea:layout>
<%
	}
%>
