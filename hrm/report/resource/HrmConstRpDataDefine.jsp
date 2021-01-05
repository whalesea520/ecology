<%@ page import="java.util.ArrayList,
                 weaver.systeminfo.SystemEnv,
                 weaver.docs.docs.CustomFieldManager"%>
<%
    ArrayList cids = new ArrayList();
    ArrayList cids2 = new ArrayList();
    ArrayList cNames = new ArrayList();
    ArrayList cFieldLabel = new ArrayList();
    ArrayList cHtmlType = new ArrayList();
    ArrayList cType = new ArrayList();
    cids.add("0");
    cids2.add("0");
    cNames.add("status");
    cFieldLabel.add(SystemEnv.getHtmlLabelName(602,user.getLanguage()));
    cHtmlType.add("100");
    cType.add("100");
    if(scopeId == 1){
        cids.add("1");
        cids2.add("1");
        cNames.add("birthday");
        cFieldLabel.add(SystemEnv.getHtmlLabelName(464,user.getLanguage()));
        cHtmlType.add("3");
        cType.add("2");

        cids.add("2");
        cids2.add("2");
        cNames.add("folk");
        cFieldLabel.add(SystemEnv.getHtmlLabelName(1886,user.getLanguage()));
        cHtmlType.add("1");
        cType.add("1");

        cids2.add("3");
        cids.add("3");
        cNames.add("regresidentplace");
        cFieldLabel.add(SystemEnv.getHtmlLabelName(15683,user.getLanguage()));
        cHtmlType.add("1");
        cType.add("1");

        cids.add("4");
        cids2.add("4");
        cNames.add("certificatenum");
        cFieldLabel.add(SystemEnv.getHtmlLabelName(1887,user.getLanguage()));
        cHtmlType.add("1");
        cType.add("1");

        cids.add("5");
        cids2.add("5");
        cNames.add("maritalstatus");
        cFieldLabel.add(SystemEnv.getHtmlLabelName(469,user.getLanguage()));
        cHtmlType.add("5");
        cType.add("2");

        cids.add("6");
        cids2.add("6");
        cNames.add("policy");
        cFieldLabel.add(SystemEnv.getHtmlLabelName(1837,user.getLanguage()));
        cHtmlType.add("1");
        cType.add("1");

        cids.add("7");
        cids2.add("7");
        cNames.add("bememberdate");
        cFieldLabel.add(SystemEnv.getHtmlLabelName(1834,user.getLanguage()));
        cHtmlType.add("3");
        cType.add("2");

        cids.add("8");
        cids2.add("8");
        cNames.add("bepartydate");
        cFieldLabel.add(SystemEnv.getHtmlLabelName(1835,user.getLanguage()));
        cHtmlType.add("3");
        cType.add("2");

        cids.add("9");
        cids2.add("9");
        cNames.add("islabouunion");
        cFieldLabel.add(SystemEnv.getHtmlLabelName(15684,user.getLanguage()));
        cHtmlType.add("5");
        cType.add("3");

        cids.add("10");
        cids2.add("10");
        cNames.add("educationlevel");
        cFieldLabel.add(SystemEnv.getHtmlLabelName(818,user.getLanguage()));
        cHtmlType.add("3");
        cType.add("30");

        cids.add("11");
        cids2.add("11");
        cNames.add("degree");
        cFieldLabel.add(SystemEnv.getHtmlLabelName(1833,user.getLanguage()));
        cHtmlType.add("1");
        cType.add("1");

        cids.add("12");
        cids2.add("12");
        cNames.add("healthinfo");
        cFieldLabel.add(SystemEnv.getHtmlLabelName(1827,user.getLanguage()));
        cHtmlType.add("5");
        cType.add("4");

        cids.add("13");
        cids2.add("13");
        cNames.add("height");
        cFieldLabel.add(SystemEnv.getHtmlLabelName(1826,user.getLanguage()));
        cHtmlType.add("1");
        cType.add("3");

        cids.add("14");
        cids2.add("14");
        cNames.add("weight");
        cFieldLabel.add(SystemEnv.getHtmlLabelName(15674,user.getLanguage()));
        cHtmlType.add("1");
        cType.add("3");

        cids.add("15");
        cids2.add("15");
        cNames.add("residentplace");
        cFieldLabel.add(SystemEnv.getHtmlLabelName(1829,user.getLanguage()));
        cHtmlType.add("1");
        cType.add("1");

        cids.add("16");
        cids2.add("16");
        cNames.add("homeaddress");
        cFieldLabel.add(SystemEnv.getHtmlLabelName(16018,user.getLanguage()));
        cHtmlType.add("1");
        cType.add("1");

        cids.add("17");
        cids2.add("17");
        cNames.add("tempresidentnumber");
        cFieldLabel.add(SystemEnv.getHtmlLabelName(15685,user.getLanguage()));
        cHtmlType.add("1");
        cType.add("1");

        int temIndex = 18;
        CustomFieldManager cfm = new CustomFieldManager("HrmCustomFieldByInfoType",scopeId);
        cfm.getCustomFields();
        while(cfm.next()){
			if(!cfm.isUse()){
				continue;
			}
            cids.add(""+temIndex);
            cids2.add(""+cfm.getId());
            cNames.add("field"+cfm.getId());
            cFieldLabel.add(SystemEnv.getHtmlLabelNames(cfm.getLable(),user.getLanguage()));
            cHtmlType.add(cfm.getHtmlType());
            if(cfm.getHtmlType().equals("5")){
                cType.add("0");
            }else{
                cType.add(cfm.getType()+"");
            }
            temIndex ++;
        }
		
		//家庭情况 5.9
        cids.add(String.valueOf(temIndex));
        cids2.add(String.valueOf(temIndex));
        cNames.add("HrmFamilyInfo_member");
        cFieldLabel.add(SystemEnv.getHtmlLabelName(431,user.getLanguage()));
        cHtmlType.add("1");
        cType.add("1");
		
		temIndex++;
        cids.add(String.valueOf(temIndex));
        cids2.add(String.valueOf(temIndex));
        cNames.add("HrmFamilyInfo_title");
        cFieldLabel.add(SystemEnv.getHtmlLabelName(1944,user.getLanguage()));
        cHtmlType.add("1");
        cType.add("1");
		
		temIndex++;
        cids.add(String.valueOf(temIndex));
        cids2.add(String.valueOf(temIndex));
        cNames.add("HrmFamilyInfo_company");
        cFieldLabel.add(SystemEnv.getHtmlLabelName(1914,user.getLanguage()));
        cHtmlType.add("1");
        cType.add("1");
		
		temIndex++;
        cids.add(String.valueOf(temIndex));
        cids2.add(String.valueOf(temIndex));
        cNames.add("HrmFamilyInfo_jobtitle");
        cFieldLabel.add(SystemEnv.getHtmlLabelName(1915,user.getLanguage()));
        cHtmlType.add("1");
        cType.add("1");
		
		temIndex++;
        cids.add(String.valueOf(temIndex));
        cids2.add(String.valueOf(temIndex));
        cNames.add("HrmFamilyInfo_address");
        cFieldLabel.add(SystemEnv.getHtmlLabelName(110,user.getLanguage()));
        cHtmlType.add("1");
        cType.add("1");
    }else if(scopeId == 3){
		int temIndex = 0;
		//工作信息 1.4
		temIndex++;
        cids.add(String.valueOf(temIndex));
        cids2.add(String.valueOf(temIndex));
        cNames.add("usekind");
        cFieldLabel.add(SystemEnv.getHtmlLabelName(804,user.getLanguage()));
        cHtmlType.add("3");
        cType.add("31");

		temIndex++;
        cids.add(String.valueOf(temIndex));
        cids2.add(String.valueOf(temIndex));
        cNames.add("startdate");
        cFieldLabel.add(SystemEnv.getHtmlLabelName(1970,user.getLanguage()));
        cHtmlType.add("3");
        cType.add("2");

		temIndex++;
        cids.add(String.valueOf(temIndex));
        cids2.add(String.valueOf(temIndex));
        cNames.add("probationenddate");
        cFieldLabel.add(SystemEnv.getHtmlLabelName(15778,user.getLanguage()));
        cHtmlType.add("3");
        cType.add("2");

		temIndex++;
        cids.add(String.valueOf(temIndex));
        cids2.add(String.valueOf(temIndex));
        cNames.add("enddate");
        cFieldLabel.add(SystemEnv.getHtmlLabelName(15236,user.getLanguage()));
        cHtmlType.add("3");
        cType.add("2");
		//added by wcd 2014-07-29 start
		//家庭情况 5.9
		temIndex++;
        cids.add(String.valueOf(temIndex));
        cids2.add(String.valueOf(temIndex));
        cNames.add("HrmFamilyInfo_member");
        cFieldLabel.add(SystemEnv.getHtmlLabelName(431,user.getLanguage()));
        cHtmlType.add("1");
        cType.add("1");
		
		temIndex++;
        cids.add(String.valueOf(temIndex));
        cids2.add(String.valueOf(temIndex));
        cNames.add("HrmFamilyInfo_title");
        cFieldLabel.add(SystemEnv.getHtmlLabelName(1944,user.getLanguage()));
        cHtmlType.add("1");
        cType.add("1");
		
		temIndex++;
        cids.add(String.valueOf(temIndex));
        cids2.add(String.valueOf(temIndex));
        cNames.add("HrmFamilyInfo_company");
        cFieldLabel.add(SystemEnv.getHtmlLabelName(1914,user.getLanguage()));
        cHtmlType.add("1");
        cType.add("1");
		
		temIndex++;
        cids.add(String.valueOf(temIndex));
        cids2.add(String.valueOf(temIndex));
        cNames.add("HrmFamilyInfo_jobtitle");
        cFieldLabel.add(SystemEnv.getHtmlLabelName(1915,user.getLanguage()));
        cHtmlType.add("1");
        cType.add("1");
		
		temIndex++;
        cids.add(String.valueOf(temIndex));
        cids2.add(String.valueOf(temIndex));
        cNames.add("HrmFamilyInfo_address");
        cFieldLabel.add(SystemEnv.getHtmlLabelName(110,user.getLanguage()));
        cHtmlType.add("1");
        cType.add("1");
		
		//语言能力 10.12
		temIndex++;
        cids.add(String.valueOf(temIndex));
        cids2.add(String.valueOf(temIndex));
        cNames.add("HrmLanguageAbility_language");
        cFieldLabel.add(SystemEnv.getHtmlLabelName(231,user.getLanguage()));
        cHtmlType.add("1");
        cType.add("1");
		
		temIndex++;
        cids.add(String.valueOf(temIndex));
        cids2.add(String.valueOf(temIndex));
        cNames.add("HrmLanguageAbility_level_n");
        cFieldLabel.add(SystemEnv.getHtmlLabelName(15715,user.getLanguage()));
        cHtmlType.add("5");
        cType.add("5");
		
		temIndex++;
        cids.add(String.valueOf(temIndex));
        cids2.add(String.valueOf(temIndex));
        cNames.add("HrmLanguageAbility_memo");
        cFieldLabel.add(SystemEnv.getHtmlLabelName(454,user.getLanguage()));
        cHtmlType.add("1");
        cType.add("1");
		
		//教育情况 13.18
		temIndex++;
        cids.add(String.valueOf(temIndex));
        cids2.add(String.valueOf(temIndex));
        cNames.add("HrmEducationInfo_school");
        cFieldLabel.add(SystemEnv.getHtmlLabelName(1903,user.getLanguage()));
        cHtmlType.add("1");
        cType.add("1");
		
		temIndex++;
        cids.add(String.valueOf(temIndex));
        cids2.add(String.valueOf(temIndex));
        cNames.add("HrmEducationInfo_speciality");
        cFieldLabel.add(SystemEnv.getHtmlLabelName(803,user.getLanguage()));
        cHtmlType.add("3");
        cType.add("119");
		temIndex++;
		
        cids.add(String.valueOf(temIndex));
        cids2.add(String.valueOf(temIndex));
        cNames.add("HrmEducationInfo_startdate");
        cFieldLabel.add(SystemEnv.getHtmlLabelName(740,user.getLanguage()));
        cHtmlType.add("3");
        cType.add("2");
		
		temIndex++;
        cids.add(String.valueOf(temIndex));
        cids2.add(String.valueOf(temIndex));
        cNames.add("HrmEducationInfo_enddate");
        cFieldLabel.add(SystemEnv.getHtmlLabelName(741,user.getLanguage()));
        cHtmlType.add("3");
        cType.add("2");
		
		temIndex++;
        cids.add(String.valueOf(temIndex));
        cids2.add(String.valueOf(temIndex));
        cNames.add("HrmEducationInfo_level");
        cFieldLabel.add(SystemEnv.getHtmlLabelName(818,user.getLanguage()));
        cHtmlType.add("3");
        cType.add("30");
		
		temIndex++;
        cids.add(String.valueOf(temIndex));
        cids2.add(String.valueOf(temIndex));
        cNames.add("HrmEducationInfo_studydesc");
        cFieldLabel.add(SystemEnv.getHtmlLabelName(1942,user.getLanguage()));
        cHtmlType.add("1");
        cType.add("1");
		
		//入职前工作简历 19.24
		temIndex++;
        cids.add(String.valueOf(temIndex));
        cids2.add(String.valueOf(temIndex));
        cNames.add("HrmWorkResume_company");
        cFieldLabel.add(SystemEnv.getHtmlLabelName(1976,user.getLanguage()));
        cHtmlType.add("1");
        cType.add("1");
		
		temIndex++;
        cids.add(String.valueOf(temIndex));
        cids2.add(String.valueOf(temIndex));
        cNames.add("HrmWorkResume_jobtitle");
        cFieldLabel.add(SystemEnv.getHtmlLabelName(1915,user.getLanguage()));
        cHtmlType.add("1");
        cType.add("1");
		
		temIndex++;
        cids.add(String.valueOf(temIndex));
        cids2.add(String.valueOf(temIndex));
        cNames.add("HrmWorkResume_startdate");
        cFieldLabel.add(SystemEnv.getHtmlLabelName(740,user.getLanguage()));
        cHtmlType.add("3");
        cType.add("2");
		
		temIndex++;
        cids.add(String.valueOf(temIndex));
        cids2.add(String.valueOf(temIndex));
        cNames.add("HrmWorkResume_enddate");
        cFieldLabel.add(SystemEnv.getHtmlLabelName(741,user.getLanguage()));
        cHtmlType.add("3");
        cType.add("2");
		
		temIndex++;
        cids.add(String.valueOf(temIndex));
        cids2.add(String.valueOf(temIndex));
        cNames.add("HrmWorkResume_workdesc");
        cFieldLabel.add(SystemEnv.getHtmlLabelName(1977,user.getLanguage()));
        cHtmlType.add("1");
        cType.add("1");
		
		temIndex++;
        cids.add(String.valueOf(temIndex));
        cids2.add(String.valueOf(temIndex));
        cNames.add("HrmWorkResume_leavereason");
        cFieldLabel.add(SystemEnv.getHtmlLabelName(15676,user.getLanguage()));
        cHtmlType.add("1");
        cType.add("1");
		
		//入职前培训 25.29
		temIndex++;
        cids.add(String.valueOf(temIndex));
        cids2.add(String.valueOf(temIndex));
        cNames.add("HrmTrainBeforeWork_trainname");
        cFieldLabel.add(SystemEnv.getHtmlLabelName(15678,user.getLanguage()));
        cHtmlType.add("1");
        cType.add("1");
		
		temIndex++;
        cids.add(String.valueOf(temIndex));
        cids2.add(String.valueOf(temIndex));
        cNames.add("HrmTrainBeforeWork_trainstartdate");
        cFieldLabel.add(SystemEnv.getHtmlLabelName(740,user.getLanguage()));
        cHtmlType.add("3");
        cType.add("2");
		
		temIndex++;
        cids.add(String.valueOf(temIndex));
        cids2.add(String.valueOf(temIndex));
        cNames.add("HrmTrainBeforeWork_trainenddate");
        cFieldLabel.add(SystemEnv.getHtmlLabelName(741,user.getLanguage()));
        cHtmlType.add("3");
        cType.add("2");
		
		temIndex++;
        cids.add(String.valueOf(temIndex));
        cids2.add(String.valueOf(temIndex));
        cNames.add("HrmTrainBeforeWork_trainresource");
        cFieldLabel.add(SystemEnv.getHtmlLabelName(1974,user.getLanguage()));
        cHtmlType.add("1");
        cType.add("1");
		temIndex++;
        cids.add(String.valueOf(temIndex));
        cids2.add(String.valueOf(temIndex));
        cNames.add("HrmTrainBeforeWork_trainmemo");
        cFieldLabel.add(SystemEnv.getHtmlLabelName(454,user.getLanguage()));
        cHtmlType.add("1");
        cType.add("1");
		
		//资格证书 30.33
		temIndex++;
        cids.add(String.valueOf(temIndex));
        cids2.add(String.valueOf(temIndex));
        cNames.add("HrmCertification_certname");
        cFieldLabel.add(SystemEnv.getHtmlLabelName(195,user.getLanguage()));
        cHtmlType.add("1");
        cType.add("1");
		
		temIndex++;
        cids.add(String.valueOf(temIndex));
        cids2.add(String.valueOf(temIndex));
        cNames.add("HrmCertification_datefrom");
        cFieldLabel.add(SystemEnv.getHtmlLabelName(740,user.getLanguage()));
        cHtmlType.add("3");
        cType.add("2");
		
		temIndex++;
        cids.add(String.valueOf(temIndex));
        cids2.add(String.valueOf(temIndex));
        cNames.add("HrmCertification_dateto");
        cFieldLabel.add(SystemEnv.getHtmlLabelName(741,user.getLanguage()));
        cHtmlType.add("3");
        cType.add("2");
		
		temIndex++;
        cids.add(String.valueOf(temIndex));
        cids2.add(String.valueOf(temIndex));
        cNames.add("HrmCertification_awardfrom");
        cFieldLabel.add(SystemEnv.getHtmlLabelName(15681,user.getLanguage()));
        cHtmlType.add("1");
        cType.add("1");
		
		//入职前奖惩 34.36
		temIndex++;
        cids.add(String.valueOf(temIndex));
        cids2.add(String.valueOf(temIndex));
        cNames.add("HrmRewardBeforeWork_rewardname");
        cFieldLabel.add(SystemEnv.getHtmlLabelName(15666,user.getLanguage()));
        cHtmlType.add("1");
        cType.add("1");
		
		temIndex++;
        cids.add(String.valueOf(temIndex));
        cids2.add(String.valueOf(temIndex));
        cNames.add("HrmRewardBeforeWork_rewarddate");
        cFieldLabel.add(SystemEnv.getHtmlLabelName(1962,user.getLanguage()));
        cHtmlType.add("3");
        cType.add("2");
		
		temIndex++;
        cids.add(String.valueOf(temIndex));
        cids2.add(String.valueOf(temIndex));
        cNames.add("HrmRewardBeforeWork_rewardmemo");
        cFieldLabel.add(SystemEnv.getHtmlLabelName(454,user.getLanguage()));
        cHtmlType.add("1");
        cType.add("1");
		//added by wcd 2014-07-29 end

		//自定义
        temIndex++;
        CustomFieldManager cfm = new CustomFieldManager("HrmCustomFieldByInfoType",scopeId);
        cfm.getCustomFields();
        while(cfm.next()){
			if(!cfm.isUse()){
				continue;
			}
            cids.add(""+temIndex);
            cids2.add(""+cfm.getId());
            cNames.add("field"+cfm.getId());
            cFieldLabel.add(SystemEnv.getHtmlLabelNames(cfm.getLable(),user.getLanguage()));
            cHtmlType.add(cfm.getHtmlType());
            if(cfm.getHtmlType().equals("5")){
                cType.add("0");
            }else{
                cType.add(cfm.getType()+"");
            }
            temIndex ++ ;
        }
    }else if(scopeId == -10){
        cids.add("1");
        cNames.add("member");
        cFieldLabel.add(SystemEnv.getHtmlLabelName(431,user.getLanguage()));
        cHtmlType.add("1");
        cType.add("1");

        cids.add("2");
        cNames.add("title");
        cFieldLabel.add(SystemEnv.getHtmlLabelName(1944,user.getLanguage()));
        cHtmlType.add("1");
        cType.add("1");

        cids.add("3");
        cNames.add("company");
        cFieldLabel.add(SystemEnv.getHtmlLabelName(1914,user.getLanguage()));
        cHtmlType.add("1");
        cType.add("1");

        cids.add("4");
        cNames.add("jobtitle");
        cFieldLabel.add(SystemEnv.getHtmlLabelName(1915,user.getLanguage()));
        cHtmlType.add("1");
        cType.add("1");

        cids.add("5");
        cNames.add("address");
        cFieldLabel.add(SystemEnv.getHtmlLabelName(110,user.getLanguage()));
        cHtmlType.add("1");
        cType.add("1");
    }else if(scopeId == -11){
        cids.add("1");
        cNames.add("language");
        cFieldLabel.add(SystemEnv.getHtmlLabelName(231,user.getLanguage()));
        cHtmlType.add("1");
        cType.add("1");

        cids.add("2");
        cNames.add("level_n");
        cFieldLabel.add(SystemEnv.getHtmlLabelName(15715,user.getLanguage()));
        cHtmlType.add("5");
        cType.add("1");

        cids.add("3");
        cNames.add("memo");
        cFieldLabel.add(SystemEnv.getHtmlLabelName(454,user.getLanguage()));
        cHtmlType.add("1");
        cType.add("1");
    }else if(scopeId == -12){
        cids.add("1");
        cNames.add("school");
        cFieldLabel.add(SystemEnv.getHtmlLabelName(1903,user.getLanguage()));
        cHtmlType.add("1");
        cType.add("1");

        cids.add("2");
        cNames.add("speciality");
        cFieldLabel.add(SystemEnv.getHtmlLabelName(803,user.getLanguage()));
        cHtmlType.add("3");
        cType.add("119");

        cids.add("3");
        cNames.add("startdate");
        cFieldLabel.add(SystemEnv.getHtmlLabelName(740,user.getLanguage()));
        cHtmlType.add("3");
        cType.add("2");

        cids.add("4");
        cNames.add("enddate");
        cFieldLabel.add(SystemEnv.getHtmlLabelName(741,user.getLanguage()));
        cHtmlType.add("3");
        cType.add("2");

        cids.add("5");
        cNames.add("educationlevel");
        cFieldLabel.add(SystemEnv.getHtmlLabelName(818,user.getLanguage()));
        cHtmlType.add("3");
        cType.add("30");

        cids.add("6");
        cNames.add("studydesc");
        cFieldLabel.add(SystemEnv.getHtmlLabelName(1942,user.getLanguage()));
        cHtmlType.add("1");
        cType.add("1");
    }else if(scopeId == -13){
        cids.add("1");
        cNames.add("company");
        cFieldLabel.add(SystemEnv.getHtmlLabelName(1976,user.getLanguage()));
        cHtmlType.add("1");
        cType.add("1");

        cids.add("2");
        cNames.add("jobtitle");
        cFieldLabel.add(SystemEnv.getHtmlLabelName(1915,user.getLanguage()));
        cHtmlType.add("1");
        cType.add("1");

        cids.add("3");
        cNames.add("startdate");
        cFieldLabel.add(SystemEnv.getHtmlLabelName(740,user.getLanguage()));
        cHtmlType.add("3");
        cType.add("2");

        cids.add("4");
        cNames.add("enddate");
        cFieldLabel.add(SystemEnv.getHtmlLabelName(741,user.getLanguage()));
        cHtmlType.add("3");
        cType.add("2");

        cids.add("5");
        cNames.add("workdesc");
        cFieldLabel.add(SystemEnv.getHtmlLabelName(1977,user.getLanguage()));
        cHtmlType.add("1");
        cType.add("1");

        cids.add("6");
        cNames.add("leavereason");
        cFieldLabel.add(SystemEnv.getHtmlLabelName(15676,user.getLanguage()));
        cHtmlType.add("1");
        cType.add("1");
    }else if(scopeId == -14){
        cids.add("1");
        cNames.add("trainname");
        cFieldLabel.add(SystemEnv.getHtmlLabelName(15678,user.getLanguage()));
        cHtmlType.add("1");
        cType.add("1");

        cids.add("2");
        cNames.add("trainstartdate");
        cFieldLabel.add(SystemEnv.getHtmlLabelName(740,user.getLanguage()));
        cHtmlType.add("3");
        cType.add("2");

        cids.add("3");
        cNames.add("trainenddate");
        cFieldLabel.add(SystemEnv.getHtmlLabelName(741,user.getLanguage()));
        cHtmlType.add("3");
        cType.add("2");

        cids.add("4");
        cNames.add("trainresource");
        cFieldLabel.add(SystemEnv.getHtmlLabelName(1974,user.getLanguage()));
        cHtmlType.add("1");
        cType.add("1");

        cids.add("5");
        cNames.add("trainmemo");
        cFieldLabel.add(SystemEnv.getHtmlLabelName(454,user.getLanguage()));
        cHtmlType.add("1");
        cType.add("1");
    }else if(scopeId == -15){
        cids.add("1");
        cNames.add("certname");
        cFieldLabel.add(SystemEnv.getHtmlLabelName(195,user.getLanguage()));
        cHtmlType.add("1");
        cType.add("1");

        cids.add("2");
        cNames.add("datefrom");
        cFieldLabel.add(SystemEnv.getHtmlLabelName(740,user.getLanguage()));
        cHtmlType.add("3");
        cType.add("2");

        cids.add("3");
        cNames.add("dateto");
        cFieldLabel.add(SystemEnv.getHtmlLabelName(741,user.getLanguage()));
        cHtmlType.add("3");
        cType.add("2");

        cids.add("4");
        cNames.add("awardfrom");
        cFieldLabel.add(SystemEnv.getHtmlLabelName(1974,user.getLanguage()));
        cHtmlType.add("1");
        cType.add("1");

    }else if(scopeId == -16){
        cids.add("1");
        cNames.add("rewardname");
        cFieldLabel.add(SystemEnv.getHtmlLabelName(15666,user.getLanguage()));
        cHtmlType.add("1");
        cType.add("1");

        cids.add("2");
        cNames.add("rewarddate");
        cFieldLabel.add(SystemEnv.getHtmlLabelName(1962,user.getLanguage()));
        cHtmlType.add("3");
        cType.add("2");

        cids.add("3");
        cNames.add("rewardmemo");
        cFieldLabel.add(SystemEnv.getHtmlLabelName(454,user.getLanguage()));
        cHtmlType.add("1");
        cType.add("1");

    }

%>