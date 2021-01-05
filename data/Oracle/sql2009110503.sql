CREATE TABLE MobileConfig ( 
    id integer not null,
    mc_type integer,
    mc_module integer,
    mc_scope integer,
    mc_name varchar(50),
    mc_value clob
    ) 
/
create sequence MobileConfig_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger MobileConfig_id_trigger
before insert on MobileConfig
for each row
begin
select MobileConfig_id.nextval into :new.id from dual;
end;
/

create or replace type pinyin_code as object(spell varchar2(10),code number)
/
create or replace type t_pinyincode is table of pinyin_code
/
create or replace function getPinYinCode return t_pinyincode Pipelined
is
Begin
  PIPE Row(pinyin_code('a', -20319)); 
  PIPE Row(pinyin_code('ai', -20317));     
  PIPE Row(pinyin_code('an', -20304));     
  PIPE Row(pinyin_code('ang', -20295));    
  PIPE Row(pinyin_code('ao', -20292));     
  PIPE Row(pinyin_code('ba', -20283));     
  PIPE Row(pinyin_code('bai', -20265));    
  PIPE Row(pinyin_code('ban', -20257));    
  PIPE Row(pinyin_code('bang', -20242));   
  PIPE Row(pinyin_code('bao', -20230));    
  PIPE Row(pinyin_code('bei', -20051));    
  PIPE Row(pinyin_code('ben', -20036));    
  PIPE Row(pinyin_code('beng', -20032));   
  PIPE Row(pinyin_code('bi', -20026));     
  PIPE Row(pinyin_code('bian', -20002));   
  PIPE Row(pinyin_code('biao', -19990));   
  PIPE Row(pinyin_code('bie', -19986));    
  PIPE Row(pinyin_code('bin', -19982));    
  PIPE Row(pinyin_code('bing', -19976));   
  PIPE Row(pinyin_code('bo', -19805));     
  PIPE Row(pinyin_code('bu', -19784));     
  PIPE Row(pinyin_code('ca', -19775));     
  PIPE Row(pinyin_code('cai', -19774));    
  PIPE Row(pinyin_code('can', -19763));    
  PIPE Row(pinyin_code('cang', -19756));   
  PIPE Row(pinyin_code('cao', -19751));    
  PIPE Row(pinyin_code('ce', -19746));     
  PIPE Row(pinyin_code('ceng', -19741));   
  PIPE Row(pinyin_code('cha', -19739));    
  PIPE Row(pinyin_code('chai', -19728));   
  PIPE Row(pinyin_code('chan', -19725));   
  PIPE Row(pinyin_code('chang', -19715));  
  PIPE Row(pinyin_code('chao', -19540));   
  PIPE Row(pinyin_code('che', -19531));    
  PIPE Row(pinyin_code('chen', -19525));   
  PIPE Row(pinyin_code('cheng', -19515));  
  PIPE Row(pinyin_code('chi', -19500));    
  PIPE Row(pinyin_code('chong', -19484));  
  PIPE Row(pinyin_code('chou', -19479));   
  PIPE Row(pinyin_code('chu', -19467));    
  PIPE Row(pinyin_code('chuai', -19289));  
  PIPE Row(pinyin_code('chuan', -19288));  
  PIPE Row(pinyin_code('chuang', -19281)); 
  PIPE Row(pinyin_code('chui', -19275));   
  PIPE Row(pinyin_code('chun', -19270));   
  PIPE Row(pinyin_code('chuo', -19263));   
  PIPE Row(pinyin_code('ci', -19261));     
  PIPE Row(pinyin_code('cong', -19249));   
  PIPE Row(pinyin_code('cou', -19243));    
  PIPE Row(pinyin_code('cu', -19242));     
  PIPE Row(pinyin_code('cuan', -19238));   
  PIPE Row(pinyin_code('cui', -19235));    
  PIPE Row(pinyin_code('cun', -19227));    
  PIPE Row(pinyin_code('cuo', -19224));    
  PIPE Row(pinyin_code('da', -19218));     
  PIPE Row(pinyin_code('dai', -19212));    
  PIPE Row(pinyin_code('dan', -19038));    
  PIPE Row(pinyin_code('dang', -19023));   
  PIPE Row(pinyin_code('dao', -19018));    
  PIPE Row(pinyin_code('de', -19006));     
  PIPE Row(pinyin_code('deng', -19003));   
  PIPE Row(pinyin_code('di', -18996));     
  PIPE Row(pinyin_code('dian', -18977));   
  PIPE Row(pinyin_code('diao', -18961));   
  PIPE Row(pinyin_code('die', -18952));    
  PIPE Row(pinyin_code('ding', -18783));   
  PIPE Row(pinyin_code('diu', -18774));    
  PIPE Row(pinyin_code('dong', -18773));   
  PIPE Row(pinyin_code('dou', -18763));    
  PIPE Row(pinyin_code('du', -18756));     
  PIPE Row(pinyin_code('duan', -18741));   
  PIPE Row(pinyin_code('dui', -18735));    
  PIPE Row(pinyin_code('dun', -18731));    
  PIPE Row(pinyin_code('duo', -18722));    
  PIPE Row(pinyin_code('e', -18710));      
  PIPE Row(pinyin_code('en', -18697));     
  PIPE Row(pinyin_code('er', -18696));     
  PIPE Row(pinyin_code('fa', -18526));     
  PIPE Row(pinyin_code('fan', -18518));    
  PIPE Row(pinyin_code('fang', -18501));   
  PIPE Row(pinyin_code('fei', -18490));    
  PIPE Row(pinyin_code('fen', -18478));    
  PIPE Row(pinyin_code('feng', -18463));   
  PIPE Row(pinyin_code('fo', -18448));     
  PIPE Row(pinyin_code('fou', -18447));    
  PIPE Row(pinyin_code('fu', -18446));     
  PIPE Row(pinyin_code('ga', -18239));     
  PIPE Row(pinyin_code('gai', -18237));    
  PIPE Row(pinyin_code('gan', -18231));    
  PIPE Row(pinyin_code('gang', -18220));   
  PIPE Row(pinyin_code('gao', -18211));    
  PIPE Row(pinyin_code('ge', -18201));     
  PIPE Row(pinyin_code('gei', -18184));    
  PIPE Row(pinyin_code('gen', -18183));    
  PIPE Row(pinyin_code('geng', -18181));   
  PIPE Row(pinyin_code('gong', -18012));   
  PIPE Row(pinyin_code('gou', -17997));    
  PIPE Row(pinyin_code('gu', -17988));     
  PIPE Row(pinyin_code('gua', -17970));    
  PIPE Row(pinyin_code('guai', -17964));   
  PIPE Row(pinyin_code('guan', -17961));   
  PIPE Row(pinyin_code('guang', -17950));  
  PIPE Row(pinyin_code('gui', -17947));    
  PIPE Row(pinyin_code('gun', -17931));    
  PIPE Row(pinyin_code('guo', -17928));    
  PIPE Row(pinyin_code('ha', -17922));     
  PIPE Row(pinyin_code('hai', -17759));    
  PIPE Row(pinyin_code('han', -17752));    
  PIPE Row(pinyin_code('hang', -17733));   
  PIPE Row(pinyin_code('hao', -17730));    
  PIPE Row(pinyin_code('he', -17721));     
  PIPE Row(pinyin_code('hei', -17703));    
  PIPE Row(pinyin_code('hen', -17701));    
  PIPE Row(pinyin_code('heng', -17697));   
  PIPE Row(pinyin_code('hong', -17692));   
  PIPE Row(pinyin_code('hou', -17683));    
  PIPE Row(pinyin_code('hu', -17676));     
  PIPE Row(pinyin_code('hua', -17496));    
  PIPE Row(pinyin_code('huai', -17487));   
  PIPE Row(pinyin_code('huan', -17482));   
  PIPE Row(pinyin_code('huang', -17468));  
  PIPE Row(pinyin_code('hui', -17454));    
  PIPE Row(pinyin_code('hun', -17433));    
  PIPE Row(pinyin_code('huo', -17427));    
  PIPE Row(pinyin_code('ji', -17417));     
  PIPE Row(pinyin_code('jia', -17202));    
  PIPE Row(pinyin_code('jian', -17185));   
  PIPE Row(pinyin_code('jiang', -16983));  
  PIPE Row(pinyin_code('jiao', -16970));   
  PIPE Row(pinyin_code('jie', -16942));    
  PIPE Row(pinyin_code('jin', -16915));    
  PIPE Row(pinyin_code('jing', -16733));   
  PIPE Row(pinyin_code('jiong', -16708));  
  PIPE Row(pinyin_code('jiu', -16706));    
  PIPE Row(pinyin_code('ju', -16689));     
  PIPE Row(pinyin_code('juan', -16664));   
  PIPE Row(pinyin_code('jue', -16657));    
  PIPE Row(pinyin_code('jun', -16647));    
  PIPE Row(pinyin_code('ka', -16474));     
  PIPE Row(pinyin_code('kai', -16470));    
  PIPE Row(pinyin_code('kan', -16465));    
  PIPE Row(pinyin_code('kang', -16459));   
  PIPE Row(pinyin_code('kao', -16452));    
  PIPE Row(pinyin_code('ke', -16448));     
  PIPE Row(pinyin_code('ken', -16433));    
  PIPE Row(pinyin_code('keng', -16429));   
  PIPE Row(pinyin_code('kong', -16427));   
  PIPE Row(pinyin_code('kou', -16423));    
  PIPE Row(pinyin_code('ku', -16419));     
  PIPE Row(pinyin_code('kua', -16412));    
  PIPE Row(pinyin_code('kuai', -16407));   
  PIPE Row(pinyin_code('kuan', -16403));   
  PIPE Row(pinyin_code('kuang', -16401));  
  PIPE Row(pinyin_code('kui', -16393));    
  PIPE Row(pinyin_code('kun', -16220));    
  PIPE Row(pinyin_code('kuo', -16216));    
  PIPE Row(pinyin_code('la', -16212));     
  PIPE Row(pinyin_code('lai', -16205));    
  PIPE Row(pinyin_code('lan', -16202));    
  PIPE Row(pinyin_code('lang', -16187));   
  PIPE Row(pinyin_code('lao', -16180));    
  PIPE Row(pinyin_code('le', -16171));     
  PIPE Row(pinyin_code('lei', -16169));    
  PIPE Row(pinyin_code('leng', -16158));   
  PIPE Row(pinyin_code('li', -16155));     
  PIPE Row(pinyin_code('lia', -15959));    
  PIPE Row(pinyin_code('lian', -15958));   
  PIPE Row(pinyin_code('liang', -15944));  
  PIPE Row(pinyin_code('liao', -15933));   
  PIPE Row(pinyin_code('lie', -15920));    
  PIPE Row(pinyin_code('lin', -15915));    
  PIPE Row(pinyin_code('ling', -15903));   
  PIPE Row(pinyin_code('liu', -15889));    
  PIPE Row(pinyin_code('long', -15878));   
  PIPE Row(pinyin_code('lou', -15707));    
  PIPE Row(pinyin_code('lu', -15701));     
  PIPE Row(pinyin_code('lv', -15681));     
  PIPE Row(pinyin_code('luan', -15667));   
  PIPE Row(pinyin_code('lue', -15661));    
  PIPE Row(pinyin_code('lun', -15659));    
  PIPE Row(pinyin_code('luo', -15652));    
  PIPE Row(pinyin_code('ma', -15640));     
  PIPE Row(pinyin_code('mai', -15631));    
  PIPE Row(pinyin_code('man', -15625));    
  PIPE Row(pinyin_code('mang', -15454));   
  PIPE Row(pinyin_code('mao', -15448));    
  PIPE Row(pinyin_code('me', -15436));     
  PIPE Row(pinyin_code('mei', -15435));    
  PIPE Row(pinyin_code('men', -15419));    
  PIPE Row(pinyin_code('meng', -15416));   
  PIPE Row(pinyin_code('mi', -15408));     
  PIPE Row(pinyin_code('mian', -15394));   
  PIPE Row(pinyin_code('miao', -15385));   
  PIPE Row(pinyin_code('mie', -15377));    
  PIPE Row(pinyin_code('min', -15375));    
  PIPE Row(pinyin_code('ming', -15369));   
  PIPE Row(pinyin_code('miu', -15363));    
  PIPE Row(pinyin_code('mo', -15362));     
  PIPE Row(pinyin_code('mou', -15183));    
  PIPE Row(pinyin_code('mu', -15180));     
  PIPE Row(pinyin_code('na', -15165));     
  PIPE Row(pinyin_code('nai', -15158));    
  PIPE Row(pinyin_code('nan', -15153));    
  PIPE Row(pinyin_code('nang', -15150));   
  PIPE Row(pinyin_code('nao', -15149));    
  PIPE Row(pinyin_code('ne', -15144));     
  PIPE Row(pinyin_code('nei', -15143));    
  PIPE Row(pinyin_code('nen', -15141));    
  PIPE Row(pinyin_code('neng', -15140));   
  PIPE Row(pinyin_code('ni', -15139));     
  PIPE Row(pinyin_code('nian', -15128));   
  PIPE Row(pinyin_code('niang', -15121));  
  PIPE Row(pinyin_code('niao', -15119));   
  PIPE Row(pinyin_code('nie', -15117));    
  PIPE Row(pinyin_code('nin', -15110));    
  PIPE Row(pinyin_code('ning', -15109));   
  PIPE Row(pinyin_code('niu', -14941));    
  PIPE Row(pinyin_code('nong', -14937));   
  PIPE Row(pinyin_code('nu', -14933));     
  PIPE Row(pinyin_code('nv', -14930));     
  PIPE Row(pinyin_code('nuan', -14929));   
  PIPE Row(pinyin_code('nue', -14928));    
  PIPE Row(pinyin_code('nuo', -14926));    
  PIPE Row(pinyin_code('o', -14922));      
  PIPE Row(pinyin_code('ou', -14921));     
  PIPE Row(pinyin_code('pa', -14914));     
  PIPE Row(pinyin_code('pai', -14908));    
  PIPE Row(pinyin_code('pan', -14902));    
  PIPE Row(pinyin_code('pang', -14894));   
  PIPE Row(pinyin_code('pao', -14889));    
  PIPE Row(pinyin_code('pei', -14882));    
  PIPE Row(pinyin_code('pen', -14873));    
  PIPE Row(pinyin_code('peng', -14871));   
  PIPE Row(pinyin_code('pi', -14857));     
  PIPE Row(pinyin_code('pian', -14678));   
  PIPE Row(pinyin_code('piao', -14674));   
  PIPE Row(pinyin_code('pie', -14670));    
  PIPE Row(pinyin_code('pin', -14668));    
  PIPE Row(pinyin_code('ping', -14663));   
  PIPE Row(pinyin_code('po', -14654));     
  PIPE Row(pinyin_code('pu', -14645));     
  PIPE Row(pinyin_code('qi', -14630));     
  PIPE Row(pinyin_code('qia', -14594));    
  PIPE Row(pinyin_code('qian', -14429));   
  PIPE Row(pinyin_code('qiang', -14407));  
  PIPE Row(pinyin_code('qiao', -14399));   
  PIPE Row(pinyin_code('qie', -14384));    
  PIPE Row(pinyin_code('qin', -14379));    
  PIPE Row(pinyin_code('qing', -14368));   
  PIPE Row(pinyin_code('qiong', -14355));  
  PIPE Row(pinyin_code('qiu', -14353));    
  PIPE Row(pinyin_code('qu', -14345));     
  PIPE Row(pinyin_code('quan', -14170));   
  PIPE Row(pinyin_code('que', -14159));    
  PIPE Row(pinyin_code('qun', -14151));    
  PIPE Row(pinyin_code('ran', -14149));    
  PIPE Row(pinyin_code('rang', -14145));   
  PIPE Row(pinyin_code('rao', -14140));    
  PIPE Row(pinyin_code('re', -14137));     
  PIPE Row(pinyin_code('ren', -14135));    
  PIPE Row(pinyin_code('reng', -14125));   
  PIPE Row(pinyin_code('ri', -14123));     
  PIPE Row(pinyin_code('rong', -14122));   
  PIPE Row(pinyin_code('rou', -14112));    
  PIPE Row(pinyin_code('ru', -14109));     
  PIPE Row(pinyin_code('ruan', -14099));   
  PIPE Row(pinyin_code('rui', -14097));    
  PIPE Row(pinyin_code('run', -14094));    
  PIPE Row(pinyin_code('ruo', -14092));    
  PIPE Row(pinyin_code('sa', -14090));     
  PIPE Row(pinyin_code('sai', -14087));    
  PIPE Row(pinyin_code('san', -14083));    
  PIPE Row(pinyin_code('sang', -13917));   
  PIPE Row(pinyin_code('sao', -13914));    
  PIPE Row(pinyin_code('se', -13910));     
  PIPE Row(pinyin_code('sen', -13907));    
  PIPE Row(pinyin_code('seng', -13906));   
  PIPE Row(pinyin_code('sha', -13905));    
  PIPE Row(pinyin_code('shai', -13896));   
  PIPE Row(pinyin_code('shan', -13894));   
  PIPE Row(pinyin_code('shang', -13878));  
  PIPE Row(pinyin_code('shao', -13870));   
  PIPE Row(pinyin_code('she', -13859));    
  PIPE Row(pinyin_code('shen', -13847));   
  PIPE Row(pinyin_code('sheng', -13831));  
  PIPE Row(pinyin_code('shi', -13658));    
  PIPE Row(pinyin_code('shou', -13611));   
  PIPE Row(pinyin_code('shu', -13601));    
  PIPE Row(pinyin_code('shua', -13406));   
  PIPE Row(pinyin_code('shuai', -13404));  
  PIPE Row(pinyin_code('shuan', -13400));  
  PIPE Row(pinyin_code('shuang', -13398)); 
  PIPE Row(pinyin_code('shui', -13395));   
  PIPE Row(pinyin_code('shun', -13391));   
  PIPE Row(pinyin_code('shuo', -13387));   
  PIPE Row(pinyin_code('si', -13383));     
  PIPE Row(pinyin_code('song', -13367));   
  PIPE Row(pinyin_code('sou', -13359));    
  PIPE Row(pinyin_code('su', -13356));     
  PIPE Row(pinyin_code('suan', -13343));   
  PIPE Row(pinyin_code('sui', -13340));    
  PIPE Row(pinyin_code('sun', -13329));    
  PIPE Row(pinyin_code('suo', -13326));    
  PIPE Row(pinyin_code('ta', -13318));     
  PIPE Row(pinyin_code('tai', -13147));    
  PIPE Row(pinyin_code('tan', -13138));    
  PIPE Row(pinyin_code('tang', -13120));   
  PIPE Row(pinyin_code('tao', -13107));    
  PIPE Row(pinyin_code('te', -13096));     
  PIPE Row(pinyin_code('teng', -13095));   
  PIPE Row(pinyin_code('ti', -13091));     
  PIPE Row(pinyin_code('tian', -13076));   
  PIPE Row(pinyin_code('tiao', -13068));   
  PIPE Row(pinyin_code('tie', -13063));    
  PIPE Row(pinyin_code('ting', -13060));   
  PIPE Row(pinyin_code('tong', -12888));   
  PIPE Row(pinyin_code('tou', -12875));    
  PIPE Row(pinyin_code('tu', -12871));     
  PIPE Row(pinyin_code('tuan', -12860));   
  PIPE Row(pinyin_code('tui', -12858));    
  PIPE Row(pinyin_code('tun', -12852));    
  PIPE Row(pinyin_code('tuo', -12849));    
  PIPE Row(pinyin_code('wa', -12838));     
  PIPE Row(pinyin_code('wai', -12831));    
  PIPE Row(pinyin_code('wan', -12829));    
  PIPE Row(pinyin_code('wang', -12812));   
  PIPE Row(pinyin_code('wei', -12802));    
  PIPE Row(pinyin_code('wen', -12607));    
  PIPE Row(pinyin_code('weng', -12597));   
  PIPE Row(pinyin_code('wo', -12594));     
  PIPE Row(pinyin_code('wu', -12585));     
  PIPE Row(pinyin_code('xi', -12556));     
  PIPE Row(pinyin_code('xia', -12359));    
  PIPE Row(pinyin_code('xian', -12346));   
  PIPE Row(pinyin_code('xiang', -12320));  
  PIPE Row(pinyin_code('xiao', -12300));   
  PIPE Row(pinyin_code('xie', -12120));    
  PIPE Row(pinyin_code('xin', -12099));    
  PIPE Row(pinyin_code('xing', -12089));   
  PIPE Row(pinyin_code('xiong', -12074));  
  PIPE Row(pinyin_code('xiu', -12067));    
  PIPE Row(pinyin_code('xu', -12058));     
  PIPE Row(pinyin_code('xuan', -12039));   
  PIPE Row(pinyin_code('xue', -11867));    
  PIPE Row(pinyin_code('xun', -11861));    
  PIPE Row(pinyin_code('ya', -11847));     
  PIPE Row(pinyin_code('yan', -11831));    
  PIPE Row(pinyin_code('yang', -11798));   
  PIPE Row(pinyin_code('yao', -11781));    
  PIPE Row(pinyin_code('ye', -11604));     
  PIPE Row(pinyin_code('yi', -11589));     
  PIPE Row(pinyin_code('yin', -11536));    
  PIPE Row(pinyin_code('ying', -11358));   
  PIPE Row(pinyin_code('yo', -11340));     
  PIPE Row(pinyin_code('yong', -11339));   
  PIPE Row(pinyin_code('you', -11324));    
  PIPE Row(pinyin_code('yu', -11303));     
  PIPE Row(pinyin_code('yuan', -11097));   
  PIPE Row(pinyin_code('yue', -11077));    
  PIPE Row(pinyin_code('yun', -11067));    
  PIPE Row(pinyin_code('za', -11055));     
  PIPE Row(pinyin_code('zai', -11052));    
  PIPE Row(pinyin_code('zan', -11045));    
  PIPE Row(pinyin_code('zang', -11041));   
  PIPE Row(pinyin_code('zao', -11038));    
  PIPE Row(pinyin_code('ze', -11024));     
  PIPE Row(pinyin_code('zei', -11020));    
  PIPE Row(pinyin_code('zen', -11019));    
  PIPE Row(pinyin_code('zeng', -11018));   
  PIPE Row(pinyin_code('zha', -11014));    
  PIPE Row(pinyin_code('zhai', -10838));   
  PIPE Row(pinyin_code('zhan', -10832));   
  PIPE Row(pinyin_code('zhang', -10815));  
  PIPE Row(pinyin_code('zhao', -10800));   
  PIPE Row(pinyin_code('zhe', -10790));    
  PIPE Row(pinyin_code('zhen', -10780));   
  PIPE Row(pinyin_code('zheng', -10764));  
  PIPE Row(pinyin_code('zhi', -10587));    
  PIPE Row(pinyin_code('zhong', -10544));  
  PIPE Row(pinyin_code('zhou', -10533));   
  PIPE Row(pinyin_code('zhu', -10519));    
  PIPE Row(pinyin_code('zhua', -10331));   
  PIPE Row(pinyin_code('zhuai', -10329));  
  PIPE Row(pinyin_code('zhuan', -10328));  
  PIPE Row(pinyin_code('zhuang', -10322)); 
  PIPE Row(pinyin_code('zhui', -10315));   
  PIPE Row(pinyin_code('zhun', -10309));   
  PIPE Row(pinyin_code('zhuo', -10307));   
  PIPE Row(pinyin_code('zi', -10296));     
  PIPE Row(pinyin_code('zong', -10281));   
  PIPE Row(pinyin_code('zou', -10274));    
  PIPE Row(pinyin_code('zu', -10270));     
  PIPE Row(pinyin_code('zuan', -10262));   
  PIPE Row(pinyin_code('zui', -10260));    
  PIPE Row(pinyin_code('zun', -10256));    
  PIPE Row(pinyin_code('zuo', -10254));    
  Return;
end;
/

create or replace function getPinYin(p_cnStr In varchar2,p_sign In number default null) return varchar2
as
  lv_spell varchar2(200);
  lv_temp Varchar2(10);
  lv_char varchar2(10);
  li_bytes Integer;
begin
  if p_cnStr is null then
    return '';
  end if;
  for i In 1..length(p_cnStr) loop
     lv_char:=substr(p_cnStr,i,1);
     if lengthb(lv_char) = 1 then
       lv_spell:=lv_spell||lv_char;
     elsif lengthb(lv_char) = 2 then
       Select ascii(lv_char)-256*256 Into li_bytes From dual;
       select max(spell) Into lv_temp from table(getPinYinCode) where code<=li_bytes;
       if p_sign is null then
         lv_spell:=lv_spell||substr(lv_temp,1,1);
       else
         lv_spell:=lv_spell||lv_temp;
       end if;
     elsif lengthb(lv_char) = 3 then
       Select ascii(lv_char)-256*256 Into li_bytes From dual;
       select max(spell) Into lv_temp from table(getPinYinCode) where code<=li_bytes;
       if p_sign is null then
         lv_spell:=lv_spell||substr(lv_char,1,1);
       else
         lv_spell:=lv_spell||lv_char;
       end if;
     end if;
  end loop;
  return lv_spell;
end;
/

CREATE OR REPLACE VIEW HrmPinYinResource AS SELECT h.*,getPinYin(lastname) as pinyinlastname FROM hrmresource h
/
