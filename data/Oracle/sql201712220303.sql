CREATE OR REPLACE FUNCTION GETPINYIN (PRM_SPELL IN VARCHAR2)
  RETURN VARCHAR2 IS
  v_index     int;
  v_midindex  int;
  v_wordbit   int;
  v_wordlength int;
  v_lang1 VARCHAR2(4000);
   V_COMPARE VARCHAR2(100);
  V_RETURN  VARCHAR2(4000);
  a number;
SPELLCODE VARCHAR2(100);
  INSPELL   VARCHAR2(4000);
  V_BITCHAR VARCHAR2(100);
  V_BITNUM  INTEGER;
  V_CHRNUM  INTEGER;
  V_STDSTR  VARCHAR2(100) := '°Å²Á´î¶ê·¢¸Á¹þ»÷-¿¦À¬ÂèÄÃÅ¶Å¾ÆÚÈ»ÈöËúÍÚ-ÍÚÎôÑ¹ÔÑ';
  V_CHARA   VARCHAR2(4000) := 'ß¹ï¹åHàÄïÍæXÞßàÈÜtþH×cö°ì\íÁàÉæÈêÓè¨ÙŒø×rèP÷oìaèñâÖÚÏÕYì”ÖOéœõcùgíù“ëˆÛûï§ë@Þîä@áíØtØåB÷öálÛêÝEëJà»âÚéáåÛÖ’÷¡÷éö—úqüÞÖæÁéOá®æñÖ“öËðÆñúòü';
  V_CHARB   VARCHAR2(4000) := 'á±ôÎášØ^÷„ôƒÜØá—ÝÃÝRïT÷Éü–îÙâZÚ•öÑõEå±êþÞãßÂì‹Ù”ívîCÞnÚæÛàîÓô²âkô‘é›ã[ì‡Þkäºß™íDÝòÖræ^ÙèæßìÒöµé–ý_Ýáï’ï–øRødÙ…ìdõÀè˜ãEìsõUètÚéùlãmØÚýã£àfÝKíÕÝíÕRÝ…ä^÷¹öÍêÚßGÙSï¼åQÛÎÛÐÝ™éaàÔìžßJÛMê´éGçaØP÷”æqùSösÝ©Ø°ßÁåþïõÙÂô°Ø„×ß›î¯ßÙÜêáùîéæ¾âØÝÉé[é]åöã¹ÙCÚPääõÏãGésïàŠæÔÞµõIå¨Û‹í@÷ÂèµàˆôÅç@íSí{ÜKÜLôxÚFèEúzú‡ü„í¾ìÔß„æQöýß…öböcØÒÙHíÜøuÛÍâíãêÜÐáŠÞÕçÂérÞgîYÞlÞmÞpÞq×ƒìáè¼ì©÷ÔïRæôûïÚì­ì®ï[Ö€Ù™çSïðïjïkïlïnèsæ»Õ•ål÷§÷B÷Mü‚ý–õ¿ß“ÙÏçÍéÄØhÙeÙfïÙáÙìEè\î éëë÷÷Æ÷ÞôWÙûä‰ÚûêvÙ÷âãuìïžðVÞðÕ@õmìhâÄà£ã\ðGÜ@÷QØÃàRÙñîàâ“ãK÷ˆõÛäcéDõNØmænùPíçè}õËô¤ë¢éÞ×LåÍîßêÎâ˜ÕcðJÞKõ³ß²øGùLûQîÐê³âbÛYà^ð¾ñ£ñ­ñÑñØñÛó÷óëóÙóÖòùñÙñÔñ¹ñ¦ð±ðÇ';
  V_CHARC   VARCHAR2(4000) := 'àêíåßnØ”ÛPï{æî÷õüoôÓè²ÖØ÷û]úIè†Ù‰àÐäîô½ç[Ü³à“üâüá¯ä¹àáè¾âÇã˜ïÊåšæ\âªìxé¶éßÛ‚ïïèdãâæ±îÎâOÙ­Þ{êèäiæ¿åîìøÕSäaâÜäýàšïâàžõðéK×‹èÚÆÝÛÕ~éˆÙæápÖçPêU×€âãåñí]îØöæ½ÝÅãÑè å_é‹öðöKüÜÉéLéMáäæÏä–÷•çL÷lêÆã®ë©äâêÛËÕkíoâ÷ìÌânêËà}ü…ÞCü{ÖšûžÜ‡íºåøÛåÞŠîJÞÓè¡àÁÕ€ÙoÖnÞå·êÚÈÜ•â\ëÖRû‰úmÚ’í×Û{Ù•ö³Úfé´ýYýZÚß×êpèßîõÚWìlîªÚXîdçdçpèKØ©èÇàJÛôîñëóÕ\õ¨ä…õ“ßêí÷àÍæÊÕvø|ùA÷ÎýcüJü[ÜÝÚdÙPßWÚmßgÜ¯õØßtÖsôùãrýXáÜß³âÁÞŒë·à´ï†ÙÑÛLãMë†ßoã‰Ú†ùúuâçÜûô©ã¿ô¾ÛŒê™ï¥ã|Ù±àüã°áOëlöÅÜPá~×‡×‰áhô{ßcéËØŒýiÛ»ØaÚnãIäzërõéúRÜXèÆèúýsýƒØ¡âðç©ØXàsÛUézÕ‘ãÀ÷íÞõà¨àÜõßçÝë°ô­å×ÝŽâ¶îËâAÙiúEêJâëý—Úïé¢é³åNæmîqÝöjùœêÝ»ácåTõžù‡ÙƒÛwõÖåÁÞußOê¡áQÚ}ÝzöºýpèqýwßÚÚeìôÜëÞeâ‘ôÙÞiï“ð@øyÞoú\ú]ÚÙnÜÊèÈæõè®çWäÈçýÕpÙzÙ{Öé¨ëíê£Ýû€û‚û›áÞéãâ§õ¡ÝýÕKÚuÛqõ¾üyõíÜAî•Ùàß¥ïéÜfè‰ìàéÁçJè­Ú~ßýã²ÝÍë¥îxß—ÛZââßuõãáiáÏïóõºûzý€ëâØÈßHï±äSåeå¤ðûö¿óøó×ò¿ò²ñéñåñÝñÒñÎñÃñ¬ó¸ó©ó¤òíòÜòÉñ¡ðîð·æöðËðÈëú';
  V_CHARD   VARCHAR2(4000) := 'ßÕÞÇàªæpÞ…Þ‡æ§âòí³ßQß_ÛQ÷°÷²æ]ÜJèNí^ý‘ý“ß¾Þaá·ß°çªåÊçéÜÜ¤Ü–ÙJÝDõ\øl÷ìÛìOünì^íñÜláGééàîFÙÙü^à¢ÝÌÕQå£ø}ÙœìKÚÔ×[üh×•ÛÊå´í¸ÝÐßTë‹ÚêWØÖß¶âáë®á’÷ô€ê‰þOëIëZìâÜ„ôîï½åuØOàâô£ê­à‡ëQáØíãïëç‹ôÆêÚhàÖïáå~íLçCÙáÝ¶êëì{îEô†ØpûMØµÚ®Û¡êsÛæèÜíÆÝB÷¾öWæ·ÞžÚÐâKé¦íûßfãdíÚßrÖBÛyàÇÛ†áÛîŒîý‚õÚücÚçÛãçèîäâšëŠô¡õõøJõMöôü—õ ùmážîöâyäHëÕ{ä”èSÛìà©Ü¦ÞéÚgëºéPÕ™õÞöøölØêçàôúá”ìwí”ü‡ç–ï}à¤ëëíÖåVîrîûïMäAßËá´ë±õ[üŠöCù…úHÕ‰Ûíá¼ëËÞ“ëØíÏëšÝúêhî×þKâ^àKôYáHékôZäWðLêLô^ô`ôaê^à½á`êAäÂèüë¹ÕiåL÷ò×xØKÚGí~÷Çèoíbíüt×˜Ù€Ü¶ì|åƒæHé²ìÑå‘ÜYîXø‹çŽí¡êŒê íÔí­ïæ×Bç…×míâÜHíïõ»ÜOãçìÀí»ÞšâgîDßqÛvßÍîìâ‡õâõyèIßáç¶ÚrÜoÜ€ôDãõêwêyÛFÛGï˜ùzð¬óýóûóìò½ñõñôñóñ×ñÖñÉñ¼ñ²ñ°ð÷óÎóÆó¼ðãðÛð´';
  V_CHARE   VARCHAR2(4000) := 'åíÞˆÝ­âeï°ÕMä~îPô‰î~ùZù[×Fæ¹ùEêißÀÜÃêqéîÛÑÚÌÜ—ãÕãµÝàØ`ÝQß]ëñïÉß{îOðIØ¬Ö@é‘åŠöùî€ötù˜×†èyý|÷{ÝìÞôíEêzÝ[öÜëXõbøÞWåÇçíîïãsðDßƒÚÙ¦Ù@ÙEð¹ò¦ðÊ';
  V_CHARF   VARCHAR2(4000) := 'áeÛÒéyíÀåzá¦ÞNïcïx÷YâCÞ¬ìÜõìÞÀçxú‹Þxî²ÜèóØœÝGïˆï‰ØÎÚúèÊîÕÚ“â[åpøhöÐô™áÝô³úJåúïwç³ìéìqö­öîöEïyäÇëèã­ì³é¼ôäÕuáôÙMïÐü”çšì]çãÜmâpëƒèûëVôšøXØk÷÷ü‹ØrÞMèMüRüvÙÇö÷å¯÷aããí¿ïLÝ×à•ähØSæ‘çQÛºìbïpüKßôÖSÙºÚRøLøPøiÙˆë€ø]ß‘ß»õÃáKôïïûõÆâaà~ØføWûŸüAüFÙìæÚÜ½ÜÀâöç¦ç¨ÜÞìðî·ÜòÛ®í‚øIíÉÝ³ÙëèõåõÝÊþEãRãVïOøDíhá¥øqÖDÛ~Ý—õHõvíêùfù›ß¼ÞÔàMáœäæÝoôfíëÚâæâØ“ê‚öÖêçÙxÝ•õVÙŽå‡å˜öûövð¥óõò¶òãòðó¾òóòÝðò';
  V_CHARG   VARCHAR2(4000) := 'ê¸Ù¤îÅæÙáåmæØÞÎôpà@ÚëÛòêàëBØdÙWÙ^æYØ¤â}ê®Þ|ÛáãïÜÕôûÞÏøNôvýžä÷ÚséÏß¦÷ ÷hêºí·ç¤äÆÚMêlî¸âGä“æsí°éÀØºízúküŽúê½çÉéÂÞ»æ€Ú¾Û¬ï¯Õaä†ÛÙæüéxømøwÖgøæŠØªàÃÜªë¡ëõéwïÓì‘ík÷ÀÖYÝ‘õsækíuÞPíRöÛÁô´íÑãtßçØ¨ôÞÝ¢âÙûfÙsùˆàQßìç®öáõ†ëÅö¡ÜpýŠýÞÃçîÝ\ì–Ø•ÚCØþçÃâhã^÷¸íxá¸èÛØxÚ¸æÅì°åÜëgêíÙéïÝÔõýÝLÝMôþì±âõYøÝž÷½úXãéÚ¬êôî¹ßEîÜâ’ü‰ØÅëûî­ù]áÄèôêöïÀíådöñöAî™ëÒïNÚoäTïWøŽßÉØÔÚ´ÙÄévêK÷¤êPöŠ÷bÝ„å]ÜIøAÞèäÊØžßkîÂëqæšè…ûX÷}ßÛèæë×Ý_ã üUáîæ£ßžàFé|öÙõqý”ôhôkþIå³âÑØÐê{Ü‰êÐØÛêÁÙF÷¬íW÷Z÷iØ­ÙòçµíÞÝöçõPõ…ÖßÃÛöáÆâuåàþÞâë½Ùåâ£é¤Ý{ðRèJß^óþóôóàóÑòåòäòÁò¼ò´ñøñæñËðáðÙðÀðóð»ð³ð§';
  V_CHARH   VARCHAR2(4000) := 'îþãxàËëÜáVõ°ï™í™ØEõA÷ýÚõêÏìÊäwínØJô_ê\ÝÕâFé\ÞþäIädîhîuÖ›ënå«ú[ôŒÞ†ç¬Ø˜î@ãìÝïàãÞ¶àÆå©×qê»å°î—ö‚Ú­àÀÛÀàAêÂîÁý†Ø€ãFãØ÷…éuûiûîMôçôŸêHíHý[ùŸèYý˜ëaÙRÛÖúQýLìeìfûSìgü\ì•èìçñûaø’ùCÞ¿èUÙêÜŸØFÞ°Ý“åÞZãÈãüÝ¦ØAâvébØDãpìô„äfÞ®ë”ÙäëŸø™üZÚ§é{äUé•é—ô\ýJãô×÷¿æAö\àCááåËàjÜ©Ø_ö×÷õ`÷cìÃéõßüã±Ü ëŒäïëiÖ—àñõúâ©ìÎéÎô–õ­îgì²æLôEö{ù–úCúKä°çúåtöUÙüá²âïìæìïìèà‚øUå×o÷Ÿí_í’÷sûIÕjåkæèîüänÖœçfú†èëÕ–Õ üXõ×øbùJà âµØŽ×’Û¨ä¡ÝÈëfØ}ïÌêaå¾çÙß€ØoæDéIûqÞSêXèG÷ßÝkÛ¼ä½åÕäñöéß§õŒöZödëÁÚòüSáåäÒåØäêéBè«ÖWå–öüÚ‡í‹çuöm÷UúŠÖeæwÚ¶ßÔêÍçõØYëDÝx÷âãÄö™ä§ÜîÞ’ßDõt×eßÜä«Üöí£èíåçà¹çÀê_ÙVÕdÞ¥ÖMî_×M×fçiêTçžìuí}×wîœãÔé’âÆðQÞFý@Ú»äãÕŸïÁØååxß«ß˜îØâ€â·éXØ›þAÖfëoïìàëÞ½èZì[ð©óóóòòºò³ò«ò¥ò¢ñþñüñëñ¥óËó¶ó³ó¨òÂòÀðúð×ðÉð­';
  V_CHARJ   VARCHAR2(4000) := 'Ø¢ß´ØÀçáÜ¸í¶ßÒØÞßóåìï|ïúê÷êåõÒøKã‚çÜÙ}Üuì´ÛÔåZëYî¿ÙŠàœëu×Ií‡ù×^çˆÜQíZúaýVèWèiýWûAá§Ø½Ù¥àBþLØCê«éêé®ÝðÚlãšÞªÛeì“ûnÝ‹Ûˆå‰ÞUçgìPúWúnÜeë|ë}Þá÷‚êªáÕ÷äô‡åæÜÁßâä©êéÙÊÛEëHôßÕHõÕö«öÝÕ‚öê÷ÙõJÛ”öaùHýTæ÷õŸ÷DìVö›÷C÷qåÈä¤çìôÂÝçõÊãeïØØjØ†æ‰û“áµÛ£àPí¢ê©îòÛOïäeî]îaø”ùGëÎÙZâ›ê§ÝÑØ]äÕêùégìyÞöçÌÝóØböäøZä’íKû…÷µ÷œùpöx×töúYí[öžè~ídàîèÅõÂíúïµÚÙê¯ôååÀå¿ÖˆôCörûxç‰ç™û{×vû|êðÚÉâVé¥ë¦ëìÚ™éfÙ`ÙÔÕÙvÚ{Û`õÝÖGæIðTæGçZÞYèaèbè{èƒÜüôøçÖ÷šíäí\÷FÖvîŽä®ç­êñánôÝáuÖ˜Ü´æ¯ÜúõÓÙÕöÞõoøŸÞBç€ú„úŒÙ®ÞØäÐë¸Ù]Û]ãqïœáèùa×K÷Rá½Ý^àÝÚŠÞIõ´×_á†ëAà®àµìŒù™ÚàæÝÚ¦ÚµÞ×Þ—èîæ¼ã]ô‚íÙöÚôÉÕmÛdîRæOõ^ï÷ºÕ]ôîÄáŽûvüTÚáÝÀâÛâËéÈèªå\Ö”æ¡Ý£êáßMçÆêîàäÙÚBý„ãþìºÝ¼ëæùXöLù~ù‚ûü û—ÚåØÙëÂÙÓã½îiåòåÉëÖÞŸæºö¦â°ÕeÛVîKìnìoçRØçìçåÄÞ›ïGîyôñãÎà±øF÷ÝôbéNíƒèÑèêÙÖöJûýnúÜÚêÞäé§è¢ôòÚ ï¸öÂÕ‡Ûgä|õLø~÷¶ù‰à`Ý]ÛRÚzÜvé…éÙùVÛžùqúGüŸýAÜìé·é°ö´þFõáýeÚªÜÄßšîÒÙÆêøÛBâ ì«ØeåðõXåáäïZöÄØ‹ÜMõ¶èLä¸ägämïÔæŒùNçîÃïÃäŸèðáúöÁÛ²ëhï…ðCàÙæÞçåáÈèöõûÚbÚ‘ßIØÊÚkâfØãÚÜâ±Þ§ø_ø`àåéÓéQïã×HõêÜBùŠÛÇç~çìßú€ý™ØÜjè‘ÜŠâxãzã—÷÷åå‹õzûŠûŽê}ÞÜðKùQùRùUð¢ðÏðÜðýóÞóÅòÔòÌò»ò±ò¡ñäñÕñÐñÊñÆñÀñ¤ðèðÕóÕóÈóÇñððÔð¯ð¨';
  V_CHARK   VARCHAR2(4000) := 'ßÇØûëÌãlï´é_ç˜ØÜÛîâýê]îøÝÜÝaïÇå|æzêGïaâéæbíèê¬ýÙ©Ý¨Ý|ÝîƒÞRãÛî«êRÜ{ç_÷KØøß’ãÊîÖâ‚é`åêèàîíêûäD÷Šõwõ‘çæéðÚîÝÝVïýâŽî§îWáfîw÷Áá³ã¡ë´æìç¼à¾äÛï¾Õnä˜ØcØ~åoï¬ÕUäLå”çHÙÅáÇÜwÜxåIùyìÜÒíîßµâ@Þ¢údØÚß Ü¥Úœ÷¼õpç«à·ÕFÙ¨ã’ØáÛ¦ßàáöëÚ÷Žà”÷d÷ÅèwÚ²ßßÑÕEÝHÚ¿Ü’ÜœÕNù\ÞÅÚ÷ÛÛæþêÜÙLÝAãkäqà—üYèkã¦êNîåÓàkí–Ø¸à­ÞñêÒî¥î`åžæKÙçÜiõÍíŸÛ“ØÑà°ã´ÝÞÖdçqè^çûï¿÷Õûdõ«åKöïöHù{úAã§ãÍé€éèéîSéŸíAípìHíTôUðâòÒóñóíóØòòòñò¤ñÌñ½ñù';
  V_CHARL   VARCHAR2(4000) := 'ååê¹íÇØÝÞhôFéJö_èníBáÁáâäµà[ßFïªånöDù„üHêãíùÙläþÙ‡îmîsù`ô¥á°ìµïçê@×E×ŽÜ_è|è”íeé­äíî½áYà¥ýœàOÝ¹ïüï¶àHÜqäZæƒãÏÕLéÝõßëáÀï©õ²ç„î‘èáîîã™õuÞLÜ~Øìêbß·ãîí‰÷¦ö˜ðEæÐçÐéÛÙúèDÞ[èhìY÷mýFÚ³ÕC×|èˆûPõªãîLî[åGïKîàÏÜ¨Ûkã¶æêà¬çÊÝñæËØ‚ä‚öâî¾äœÖ‚árÞ¼ß†áëxõ”ç\öPùv÷óèg÷~ûZþGÙµæ²åÎï®ØNýŸä‡å¢õŽõ·÷¯ßŠ÷kß¿ÛÞÜÂìåèÀÙ³èÝÚ\éöÛªáûíÂÝ°à¦ôÏîºõÈö¨äàãWøEë_øtë`ûáBúbû•ÜVÞ]×Þ^ìZ÷uìcÞÆßBöãå¥ì¡ÛšÖ‹æ`×`ôHç ö–çöÝüà˜æ®éçé¬äòåbå€æœönýé£ÞcÜ®õÔÝˆ÷ËôuÝgÕÝvåyÜGàÚå¼â²çÔß|ØIÙ’ÛŽç‚ïmúîÉá‘à€Þ¤éRÞÍßÖÙýä£Þ˜ÛøÞæôóïVõhø•õñôQ÷à÷vßøôÔàëOý á×åàê¥î¬û‹ÞOçl÷ë÷[âÞãÁéÝïCÙUÝþì¢éŠÜCõïÜ\ÜkÞ`àòãöÜßèÚê²û_èùç±ôáÚšÝCâéqÝsë‘ä™ë™õCöìøoûwëëžýhÛ¹öNýgáì`û™ý’êtîIßÊìÖä¯ì¼åÞæòïvïÖûméHöÌæyûˆçBïdçsïiö†úVç¸ï³äÛ‰ìCëwïfôjúwãñÜ×èÐççëÊíÃýˆçXìNýýŽØLÜ[èxì_ûTÛâë]ÚLÙÍà¶ÝäßsÖŒÜ}÷ÃíVáÐïÎçUààß£ÛäãòèÓëÍéñôµâ„öÔô—Þ_èzïB÷|ûRüuûuô”éÖïåæ”çœèuéûê‘äËåÖÙTÝ`äõÚ€Ûjê¤áXä›åhåjè´øšÛÞAçGöIùcùnçeú˜ëªãÌéµé‚úyàLïùëöäXèrèïÙõöÇùFèŽû[á›ï²äsäxàðêÛiÝ†ä—öMÕ“ÞÛîbâ¤ëáé¡ïÝæ ß‰úŸèŒÙÀÜsÙùãøÜýçóÞûäðöÃõiðµðÓóüóöóÒó»ó¹ò÷òëòÛòÈòÃñöñ®ñªñ§ðüðøðìðßðÝðØðÒð½ñïñìñçñÜñÚñÏñÍð¿';
  V_CHARM   VARCHAR2(4000) := 'æÖáïßjæ‹úiö‡è¿éUßéôKö²Ý¤ÙIú”Û½ûœÙuß~ì@ìAî”÷´÷©ôMôNö æžà„Ü¬á£çÏì×ïÜÖ™çNÚøíËâIèšä€äÝØˆêóì¸ÜšáF÷Öå^ùšá¹ã÷ÜâêÄãTë£ÙóÙQà|è£î¦àŽí®Ý®àdáÒäØâ­é¹ïÑäYæ[úBüqä¼ÜzæVüeÚ›ômíi÷ÈÞÑîÍéTéYå{ìËí¯ë‰ÝùÞ«à‘à–ëüíæõ’ô¿ûsìXîŸûLÛÂô»åiãÂöQü€ìDìWÛ_ßäìòâ¨Öi÷ãû†÷çû”ÞÂéSá‚áƒûJáˆØÂåôôÍëßãÚ¢ôéãèåµÚ×à×ü†Ökå²ãæö¼ííäÏëïõ|ìrû ü@üMüIß÷ù‘÷]èÂíðíµç¿åãØ¿ßãøpèf÷xáºçäÜåçëçÅâŒÙ‚ä øsæFãÉãýéhíªüwé}÷ªöšÜøÚ¤àpäéêÔã‘øQî¨õ¤çÑÖ‡ÚÓæÆâÉüN÷áôžÖƒÖ„×OüOéâÜÔï÷Ø{Ýëõöã€ì…ïÒôŽüaõøæŸßèÙ°íøãwÖ\öÊøœüEë¤ãaÛ[ØïãåÛéÜÙîâë‚ãfëŽíJðÅñÇðÌó·ó±ó¡òþòýòúòìòÖòµóúóºò©ñòñ¢';
  V_CHARN   VARCHAR2(4000) := 'ÕyïÕæ“ë~ëÇÞàØvÜ˜Øyâcì„ô›ÜµÞ•áèÍÝÁØ¾åràïà«ßaéªÖQëyôöëîàìôTâÎêÙß­ýQØ«ßÎíÐîóâ®×DçtÛñè§émô[Ú«ðHõƒõàÅâ…äGÛèâõà\îêâ¥ÛCâ‰ØƒÝröòöFûŒýuÙ£ì»ãbëWèXÞ‹êÇíþöÓõRöóùDöTéýÝ‚ÛœÜTØ¥Ûþá|á„ÜàôÁøBæÕëåí±Úíô«êŸà¿ãcÛWÛfÛhåRõææ‡êEÞÁým×‘Übè‡ïDèßÌè_ôVûHØúå¸æ¤âîáðâoìÙ¯ßæÞrÞsáxýP×aæeç×kæÛæååóæÀîÏâSí¤ô¬üQàGÙÐßößSÞùï»ÖZÛåŸð¤ò¨ñ÷ñññÄòïòÍ';
  V_CHARO   VARCHAR2(4000) := 'àÞíMÚ©ê±økÖŽæ–útý{âæñî';
  V_CHARP   VARCHAR2(4000) := 'ÝâèËÙ½Ý‡ßßÝåæWãÝÛAõçÛ˜æoíQãúîGäƒùbè‹ë„äèìQåÌ÷›ý‰ý‹ö„ëãâÒáóÞËÝNìŽûƒüBõ¬êkêŠïÂÙräžàúì·àÎö¬Þ\äÔâñÝJéoàØÜ¡Ý~åAíŠíŽùiôJèmÛsêCØ§ç¢ÚüîëØwâWâtâ”ãYãàèäšåCõBêVêoÜÅèÁÛ¯ÚðÛýØu÷‰î¼ëRô“õQõùùdÜ±âÏØòÛÜã›Õ|øaß¨äÄæÇî¢ê¶úûGêúôæú@æéëÝÙXÕ—õäÚÒÙGÕ›ôØâçÎïgïhôwêQéèî©áoî’àÑæÎë­Ø¯ÜÖçvæ°ØšæÉîlïAé¯êòæ³Ù·îZàZèÒÝZöÒÝƒõGîÇá•áNáwçkÛ¶ÖcØÏîÞãOçêîHïHÞåÙöê·ë¶ê†àÛäõ‹ÙéáTè±å§ïäÙŸçhäßë«ÖEïè×Võëç’ð«ñâñáó¦ó²óáóÍó´óªòçò·ò­ñÈñ±ðå';
  V_CHARQ   VARCHAR2(4000) := 'Þ€èçàVÝÂàÒéÊÕƒÛpÖ[ë’õèôtçKù†ØÁÛßáªÜÎêÈä¿Ý½Ú–Ü™âHæëçùç÷ì÷þDèŸí ônôoôëýRÞ­ÛaåW÷’÷¢õšùuù}÷èôGôyö’û˜ßŒá¨Ü»è½ØMç²ôìÖHêMãàÜùÝÝíÓí¬ÝÖÚžáMì—÷ÄÚäÜ·ÙÝá©ã¥Ø@âTâ`ëeí©ãUå¹ûeåºÕßwå½ÖtîvçcùkèBôRôSíaÝ¡îÔÞçÜâjã@ãQäEåXæZübö‘ÛÉëÉã»ç××lècÜÍÜçÙ»èýÝ€ãÞê¨õÄïºïÏäÛ„ïêÛ–æjçIçjæÍéÉÖmôÇìÁíÍàbàzõÎàƒà…ØäÛ^îNçØå æ@Ú‰ÜEÜFèAÜñÚÛã¾÷³éÔ×SÚˆçyíXî˜á ã¸Ú½ê~ÕVímíIÜNæªêüã«ïÆôŠÛoå›ö@çƒôÀÕWîzõÜËâsëdàºäÚì€àßøVéÕÚ_Úcï·äußÄÞììiàWàõÝXÝpöëõ›è[éÑ÷ôÜÜí•Õˆö¥ìmíàõ¼öÆÚöÜäÚ^é±ûjÚ‚öúíFíGöpöqù”÷Gý•áìÙ´ÞåÏá–êäâUÛÏåÙôÃÙgäMábõF÷üõ‰ùj÷AôÜá«Ú°êrìîÕoüLõ@Ú…üDÜ|ôð÷ñö÷OÛ¾ëÔÝ@Þ¡íáøzè³üšÞ¾ë¬áéÜdèŠûYýxÞ‘àTãÖêïé‰üCé˜üzãªçzÚ¹ÜõéúîýÛIÝbãŒÛmêB÷™÷ÜöeýjïEáëî°ç¹íjí¨ã×ãÚÚ|é êIùoåÒð¶òøòéòàòßòÞòÓòÐòËòÇóéóæóäóÜóÌóÀó½òûò°ò¯ñýñûñßñ·ñ³';
  V_CHARR   VARCHAR2(4000) := '÷×ÜÛìüÜ`ôX×j×ŒÜéèãæ¬ëNßvØéâmôã…øžÜóïþÜrØð×šéíâ¿í¥ÜÝØìzì~ígïƒÕJïšÞwê—âJâ~ëÀáõáÉéÅéFægÝPôÛõåÝŠåˆ÷·ökù’íqßï¨ãœønàéå¦Þ¸ø›á}îž÷pàrÞzä²äáçÈÝêøMëÃÜ›Ý‰Þ¨ÜÇèÄî£äJä„écétÙ¼àeö}ö”úUð¦óèòîòÅò¸ò¬ñÅñà';
  V_CHARS   VARCHAR2(4000) := 'ØíìƒØ¦è•ìªëÛâlëMïSàçî|öwÙë§ôLôÖâÌçDédÞúíßærî‹çÒëýöþïbö…÷fÜ£ØÄï¤ëäCÞQçmÖ ïoôOé~ï¡ôÄô‹öèéŒæ|õõßþì¦é„ö®áêßÜÏæ©îÌÛïô®Ü‘áŸé^õÇäúëþõŠê„éWÚ¨ØßÚ]ãˆæóÛ·æÓÖb×iÙ ç—÷­÷W÷XéäõüìØÖ…ôlÛðÙpèlç´ô¹ÝiïYõ}ÜæÛ¿äûâ¦î´ÝfÙdÙhÙÜØÇäÜís÷êÚ·÷“õ˜ù_öYöŸãhö•ß•ßÓïòÚÅ×ŸäÉÕ”îTô×}ëÏé©ävêjê…ê’þJãHå•ü›ù|äÅ×W÷jíòêÉÙKáÓÙ‹ßŸû\âPÝéãAõ§øOø[öõåœöXö‰úPá‡â»ÞyïzìÂÛõÝªßYãJãvöåõZüœ×Rüöˆõ¹âìêêÛéøîæá‹ß±ÚÖÙBÝYâ‹âžï—ßmäKÕœÕžß}ðSÖuáŒö|ýaÞÐô¼á÷ç·æì¯ç£êxæ­Ù¿ÝÄÜ“àgÞóë¨ÛSÛ\Ý”õ_ùeïøÛÓÚHü“÷núž÷tãðëòã_äøØQåfçTùŽùà§ÕXãÅéVäÌþBëpæ×ú{ûtûUç`Õlãßéjí˜ôBÕfÕhåùîåàÊÞ÷ÝôéÃælèpÛÌæùßÐçÁãjïtØËäFïÈäùälæJï\çrúƒýDãáÙîæ¦ìëãôæáÙ¹ï~âLØ|â–ï•âìÚ¡áÂäÁÝ¿áÔã¤ížÕbæànà²äÑâÈì¬ïËágæ}ï`ÛÅàÕî¤Þ´öÕõ‡Ùíä³ÚÕà¼ãºßiûhÝøö¢Úxßpä_ðMÖqÛ‘÷Tú‰â¡Ý´íõî¡å¡ìšëmßUëSÚÇÕrÙwìÝåäçw×\ç›áøÝ¥â¸ïŠöÀé¾æ{úZæ¶êýèøíüàÂôÈÚtõ€ßïæaæiæææ•ßCð£ð¸ðÞððóßóÓóÏóÂóµó°ó§òôòÙóùóâò×òÏòªñêñµðþ';
  V_CHART   VARCHAR2(4000) := 'õÁîèäâãBÜDõ]÷£öãËßeåÝê`é½ÕwåJìŸêFíOêY×nÜcææÛ¢ìÆõÌöØïUõTÞ·ëÄîÑâØê¼Û°ïÄÕ„á]åUît×TØáv×Zú‚ìþîããgáaêæÙyï¦ôÊïÛÛçMç|íUü‘â¼àoäçëGè©éÌÛ}ÚZõ±æhêOúSàûÙÎéEæ†è’èºï‘ÖzíNíw÷ÒÞä¬ßûìŠá[ì’ä•åcØ»ìýß¯Ø–ï«í«äˆü’ëøß‚Ö`öŒìLäRúeúfç°ç¾ßXÚ„õ®ÖpÛ‡å÷–ø˜î}õ{ùYö[ù•ù—ÜnÜƒÙÃã©åÑßPç‘ÚŒáLìjüVìpî±ãÙø‰êDúcúlãÃéåï›Ùqå`ìtÞÝÙ¬ìöö¶äpì›÷ØöæõæxýföœÕAôÐï¢Úqî\ÝÆÙNÛ@âŸãŽø‡ç“ç”èFï”÷Ñî®ì˜ß‹ÜðæÃÝãéƒöªÖFüžèèîúïFÕPäbîcàÌÙÚÙ¡ÜííÅÚUãPÙ×ãnã~ï ÷‹äüõjâúæBÙï÷»î^üWäŒùWýCÝ±âŠÛTõ©å„ùIùúhú“îÊâQÞƒÜ¢ÝËùrØ‡ÞÒæ˜úoú™î¶åèëPîjîkînôsÛÛƒìÕêÕü`â½ØZëàÜ”ï‚÷ƒôë˜ÙÛØ±×™ï€ô…Ù¢êuÛçãûÞèÞíÈõÉõ¢Û|éÒõDørü˜ö¾üƒâÕùKözèØÚ—ðÃñ»óêóÔó«ó¥òèòÑñíñÓ';
  V_CHARW   VARCHAR2(4000) := 'æ´ü|Øôßœëðící€áËî“ØàæýÜ¹Ø™îBßÝ¸çºëäÝÒçþîµÝnÛläjå†ä[åsÙ–æ~Ú@Øèã¯éþÕsÝy÷ÍÞ‚ÙËåÔêžÚñÝÚìÐÞ±÷˜ögöhàíÛ×àøãíãÇífä¶á¡áÍß`àŒáWå…éõdìSìTì¿çâä¢æ¸ÚÃÚóâ«ôºè¸öÛÕ†ÛcílîQå—õnítï]í|ê¦â¬Ö^åMõKÞEçAìG÷×~ÜZ×ˆÜ^ÞdØnÝ˜Ýœ÷—æ’ö€ö“ãÓâ†ö©ô•øYøjéé”éšü•êZê[ØØãëî‚è·ûlæfúOÝîÞ³ýNÙÁÝ«à¸Ûbë¿á¢ä×íÒö»ý}ÛØÚùÚâEàwÕGÕ_øŒæuöƒàNßíä´ûcùMõˆ÷ùú~ØõåüâÐâèâäåÃêõåqù^ÜRØ£þ@Úãè»ÜÌßAìÉæÄëFì}æðå»Õ`öÈëœýHìFýIúFðÄòêòÚðôðíðÍ';
  V_CHARX   VARCHAR2(4000) := 'ÙâÚÀÛ­ßñÞÉä»ì¤äÀÝ¾ÚTâRôÑôâô¸àqÙÒÕOØgðFæÒðOéØì¨ìäôËåaØGØHØlØ‰ëvõ–ùT×@õµç^ë^êØá@÷ûú è„àEêêÚvÚôÖæˆìI÷žïe÷@çôáãÝßâ|åïÝûãŠìûÖLÖlÛ’÷^Ühâ¾Û§àSâMãÒôªÚiìùÚVëKü_ô]êSìUßÈØBéiïPöyáòèÔêƒíÌê˜åÚè¦ÚYô Ý å’æ_÷ïúTépÕ’ç]ë¯ììôÌÝ²èõÑõ£ã”åßí„åvåwí†õrÛŸ×]úNÜ]÷€æµéeã•ÕtÙtÖPÝá_ûyÚDèvú‘ú’úšÙþáýê“Ú`õÐëUÞºå‚ìÞî‡í`ï@á­ÜÈêˆÕ^ä}åDØRüGçoö±ýEÜ¼à_àlàmç½ÝÙàxæøû‘÷`è‚âÔÛKâÃ÷Ïã}ðAößõaõœí‘÷zí—ç}÷PèÉßØèÕæçç¯åÐû^äìÛXäN÷Ìø{Öyø“újàUáÅÕqÖjÕ[þMÙÉÛÄß¢çÓÖCíPèH×ýšç¥ÙôäÍéÇé¿í…âÝâ³Þ¯åâÛÆÖxíCå¬ý^ýkýKÜaõóâàß”ê¿Ý·âdì§ä\Ü°öÎôgç†êcØ¶ÜŒîˆá…Ö_õSö]ÚêàDè—ê€íÊè™â]ãoã‹ätß©Üôã¬þNÜº×›×œßÝâÓõ÷âÊã–÷ÛæTõxø æ™ïqá¶äåäPçVçnýMíìí¹çï× íšíœôqÕšÖžôzè`ôPÚ¼èòà†ôÚõ¯äªÛÃäÓìãÙ[ã„÷rÞ£ÜŽÚÎÞïÝæêÑìÓÙØÕÖXæM×Xö~×zäöè¯ßxãùìÅîçäÖé¸ãCíÛïàìœïXæ›ÚKÞjíYí´û`õ½ëzú›ÞG÷¨÷LÚÊÚpÖoÛ÷â´Þ¹êÖõ¸á¾âþä­ä±Ü÷à‰öà÷S÷\áßÞ™ÙãßdÙbÞ¦îšèRðªóïóãóÚóÁó­ó¬ó£òáò¹ñãñ¶ðïðçðÂð¼';
  V_CHARY   VARCHAR2(4000) := 'Ñ¹èâè›øfåEø†ùsçŒØóá¬çðíýý\åÂÛëæ«í¼ë²Þëý…âûëÙáÃÝÎäÎëçÛ³æÌáZéŽüiÚ¥ãÆåûÜ¾àIéZééÜîî†û’û}ûšÙðÙ²ÙÈØÉÛ±áDçüßVëCî»÷ÊÜyüdöoùžüfýdýŒüjükî›ýBô|÷úýzüsêÌêšìÍäÙøHõ¦ÚÝ÷ÐøeÖVØÍôeø‘àÙžÜ‚ázú`ÚIÚJ×…á€úŽá‰×—ØVØWãóãZë‡÷±å}ø„êgì¾è–ïráàìÈê–ÖUÝŒåø—ï^ç{öuìRûFÝIðBâóí¦çÛØ²ßºø^Ø³ëÈé÷çòÝUáæßbã“ïuïŸðPôíÖ{Ö|æc÷¥ï_î–öŽèÃáÊø€é™ýoúrì‰ýGê×ú_×Šè€ÞÞîôâXäyæUÚþí“êÊìÇÚËàvà’ØÌÖ]æEædùwìvûEÞvßÞâ¢àcì¥äôãžàæûpát÷ð×búsüpÛÝÚ±âùåÆâÂß×ÜèêÝÞ–íôôýÙOÕBÛDí›ïßzîUîVáÚî{õkÖ–çF×‚û@Þ~îÆÜÓô¯áÞ ârãiøCì½Ý}î‰ÞTýtß®Ø×ØîêdØýß½Ù«á»âøæäÞÈÞÄôàéóã¨ÞÚØ—ê‹ÛüØ[Ø\âNëcÚ˜ÝWâzçËìˆìÚÕxï×ûkûoü]ØæéìÞ²ôèØŠõlÙ“æ„ïîØsìJöGù€ùù‹×g×háyá{èOú^úgÜ²ú…úœ×”ý~êfä¦ë³êŽî÷ê”ê›à³Ü§ãŸìÖNë–éžë íÛóáþâwý‡Û´â¹Õzãyö¸ö¯ý]ýlúÛÈßÅâYâiï‹ëLì‚ï‡Úyë[×ÜáØ·áSõgÝºçøéAàÓÞüÙaè¬ë›øŠâßíŒævúD×súLè]úˆÜ…ú—ûKûWÜãÜþÝÓéºäÞÝöäëÙøÖhå­ÚAÛ«ïIîeçëôì™×Gà¡çßà{Ü­ã¼äVÛÕàaïÞëtçO÷«÷Ó÷Iúxà¯ïJî„öÙ¸÷‘Ûxõ—ákØüßÏû~à›ÞÌèÖÝ¯ÝµÞœà]ßKß[öÏéàâ™÷†ÝjôœÝ’õOßˆØÕÝ¬îðäBë»÷îÙ§àóå¶Þ”ØzáRÕT÷øæúÞ}ê|ßŽæ¥ì£ì¶ô§Ø®ô¨áüÚÄáCâÅÝÇâDêœö§ô~áÎÞíëéè¤êìÕ˜ëkðNôˆÛuÝ›å“Ö~õ‚öVöiú}ûCØñÙ¶àôàöâ×àhèžÕZäoö¹Ø…û‡ýrí²åýâÀêÅîÚþCÚÍßNãÐï„ìÏÝ÷â•îAØ¹ÝhãƒëTßyä`ø\ìÛÖIå[é“øƒø…øˆôráqùO×uÞXçŸìMå÷÷Nú–ûOÜ†ôcôdíóûgøSä‘øxùtüŒüÚOß–ãäë¼Ø’áJâƒö½Ü«ô’à÷éÚÖwÞ@üxæ…ß‡ù úMßRßhÛùæÂÞòè¥îŠë¾Ü‹îáÚ”â_ãXé†é‡éÐÙßå®ügÜSûNý›ûVÚSîfÙšç¡Ü¿êÀàyë…ëµä]êmáñéæâqëEìBýqýyÛ©ã¢àiã³ß\è¹ìÙÙ„ádájíríyíð®ðÐðéðöó¢òöòõòæòâòÕòÊòÄò¾ò£ñÁóîóÛóÄó¿ñ¿ñ¾ñºñ´ñ¯ñ«ñ¨ðùðõðêðàðÖðÎðÁð°';
  V_CHARZ   VARCHAR2(4000) := 'Ø´ØÆØÓØëØùÙªÙ¾ÙÌÙÞÚ£Ú¯ÚºÚÁÚÂÚÑÚØÚÚÚÞÚèÚìÚîÛ¤Û¥ÛµÛ¸ÛÚÛúÜÆÜÑÜïÝ§ÝÏÝèÞ©ÞÊÞÙÞêÞøÞýß¡ß¤ßªß¬ß¸ßÆßåßîßðßòßõßùßúàùàýá¤á¿áÌáÑáÖáçâ¯âÍâåâôã·ä¥ä¨ä·ä¾äÃäóåªåÅåéåëæ¢æ¨æÑæÜæàæãæíæïæûç§ç»çÄçÇçÕçÚçÞè°è¶èÌèÎèÏè×èÙèäèåè÷èþé«é»éÆéÍé×éòéôéùéüê¢ê°êµê¾êÃêÞêßêâëÆëÐëÑëÓëÕëÞëêëùì¹ìÄìíìñìóìõìúí§í½íÄíÎíØíÝíéíöî³îÀîÈîÛîùï£ï­ïÅïßïíïñïôïöð¡ð²ðºðÑðäðæðëðññ©ñ¸ñÞñèò§òÆòÎòØó®ó¯óÃóÉóÊóÐóÝóåóçóðô¢ô¦ô±ô¶ô·ôÒôÕôØôãôêôõô÷ôüõ¥õÅõÙõÜõàõîõòõôõþö£ö¤ö·öÉöíöö÷®÷Ú÷æ÷þ';
  FUNCTION F_NLSSORT(P_WORD IN VARCHAR2) RETURN VARCHAR2 AS
  BEGIN RETURN NLSSORT(P_WORD, 'NLS_SORT=SCHINESE_PINYIN_M'); END;
begin
 select instr(PRM_SPELL, '~`~`') into v_index from dual;
 select instr(PRM_SPELL, '`~`', 1, 2) into v_midindex from dual;
 select lengthb(PRM_SPELL) into v_wordbit from dual;
 select length(PRM_SPELL) into v_wordlength from dual;
 if (v_index < 0 AND v_wordbit<>v_wordlength ) then
	v_lang1 := PRM_SPELL;
 elsif (v_index >0) then
    v_lang1 := substr(PRM_SPELL, v_index + 6, v_midindex - v_index - 6);
 else
     RETURN PRM_SPELL;
 end if;
 
 select count(*)  into a from dual  where userenv('LANGUAGE') like '%GBK%';
   
   if false then
   
   BEGIN
      IF v_lang1 IS NULL OR LENGTH(TRIM(v_lang1)) = 0 THEN
        SPELLCODE := '';
      ELSE
        INSPELL := UPPER(v_lang1);
        dbms_output.put_line(INSPELL);
        SPELLCODE := '';
        FOR V_BITNUM IN 1 .. LENGTH(INSPELL) LOOP
          dbms_output.put_line(LENGTH(INSPELL));
          dbms_output.put_line(V_BITNUM);
          V_BITCHAR := SUBSTR(INSPELL, V_BITNUM, 1);
          dbms_output.put_line(V_BITCHAR);
          IF V_BITCHAR >= '°¡' AND V_BITCHAR <= '×ù' THEN
            FOR V_CHRNUM IN 1 .. LENGTH(V_STDSTR) LOOP
              IF SUBSTR(V_STDSTR, V_CHRNUM, 1) = '-' THEN
                NULL;
              ELSIF V_BITCHAR < SUBSTR(V_STDSTR, V_CHRNUM, 1) THEN
                SPELLCODE := SPELLCODE || CHR(64 + V_CHRNUM);
                EXIT;
              END IF;
            END LOOP;
            IF V_BITCHAR >= 'ÔÑ' THEN
              SPELLCODE := SPELLCODE || 'Z';
            END IF;
          ELSIF ASCII(V_BITCHAR) < 256 THEN
            SPELLCODE := SPELLCODE || V_BITCHAR;
          ELSIF INSTR('¢ñ¢ò¢ó¢ô¢õ¢ö¢ø¢ø¢ù', V_BITCHAR) > 0 THEN
            SPELLCODE := SPELLCODE || CHR(ASCII(V_BITCHAR) - 41664);
          ELSIF INSTR('£Á£Â£Ã£Ä£Å£Æ£Ç£È£É£Ê£Ë£Ì£Í£Î£Ï£Ð£Ñ£Ò£Ó£Ô£Õ£Ö£×£Ø£Ù£Ú',
                      V_BITCHAR) > 0 THEN
            SPELLCODE := SpellCode || chr(ascii(v_BitChar) - 41856);
          ELSIF INSTR('¦¡¦Á', V_BITCHAR) > 0 THEN
            SPELLCODE := SPELLCODE || 'A';
          ELSIF INSTR('¦¢¦Â', V_BITCHAR) > 0 THEN
            SPELLCODE := SPELLCODE || 'B';
          ELSIF INSTR('¦£¦Ã', V_BITCHAR) > 0 THEN
            SPELLCODE := SPELLCODE || 'G';
          ELSIF INSTR(V_CHARA, V_BITCHAR) > 0 THEN
            SPELLCODE := SPELLCODE || 'A';
          ELSIF INSTR(V_CHARB, V_BITCHAR) > 0 THEN
            SPELLCODE := SPELLCODE || 'B';
          ELSIF INSTR(V_CHARC, V_BITCHAR) > 0 THEN
            SPELLCODE := SPELLCODE || 'C';
          ELSIF INSTR(V_CHARD, V_BITCHAR) > 0 THEN
            SPELLCODE := SPELLCODE || 'D';
          ELSIF INSTR(V_CHARE, V_BITCHAR) > 0 THEN
            SPELLCODE := SPELLCODE || 'E';
          ELSIF INSTR(V_CHARF, V_BITCHAR) > 0 THEN
            SPELLCODE := SPELLCODE || 'F';
          ELSIF INSTR(V_CHARG, V_BITCHAR) > 0 THEN
            SPELLCODE := SPELLCODE || 'G';
          ELSIF INSTR(V_CHARH, V_BITCHAR) > 0 THEN
            SPELLCODE := SPELLCODE || 'H';
          ELSIF INSTR(V_CHARJ, V_BITCHAR) > 0 THEN
            SPELLCODE := SPELLCODE || 'J';
          ELSIF INSTR(V_CHARK, V_BITCHAR) > 0 THEN
            SPELLCODE := SPELLCODE || 'K';
          ELSIF INSTR(V_CHARL, V_BITCHAR) > 0 THEN
            SPELLCODE := SPELLCODE || 'L';
          ELSIF INSTR(V_CHARM, V_BITCHAR) > 0 THEN
            SPELLCODE := SPELLCODE || 'M';
          ELSIF INSTR(V_CHARN, V_BITCHAR) > 0 THEN
            SPELLCODE := SPELLCODE || 'N';
          ELSIF INSTR(V_CHARO, V_BITCHAR) > 0 THEN
            SPELLCODE := SPELLCODE || 'O';
          ELSIF INSTR(V_CHARP, V_BITCHAR) > 0 THEN
            SPELLCODE := SPELLCODE || 'P';
          ELSIF INSTR(V_CHARQ, V_BITCHAR) > 0 THEN
            SPELLCODE := SPELLCODE || 'Q';
          ELSIF INSTR(V_CHARR, V_BITCHAR) > 0 THEN
            SPELLCODE := SPELLCODE || 'R';
          ELSIF INSTR(V_CHARS, V_BITCHAR) > 0 THEN
            SPELLCODE := SPELLCODE || 'S';
          ELSIF INSTR(V_CHART, V_BITCHAR) > 0 THEN
            SPELLCODE := SPELLCODE || 'T';
          ELSIF INSTR(V_CHARW, V_BITCHAR) > 0 THEN
            SPELLCODE := SPELLCODE || 'W';
          ELSIF INSTR(V_CHARX, V_BITCHAR) > 0 THEN
            SPELLCODE := SPELLCODE || 'X';
          ELSIF INSTR(V_CHARY, V_BITCHAR) > 0 THEN
            SPELLCODE := SPELLCODE || 'Y';
          ELSIF INSTR(V_CHARZ, V_BITCHAR) > 0 THEN
            SPELLCODE := SPELLCODE || 'Z';
          END IF;
          EXIT WHEN LENGTH(SPELLCODE) > 19;
        END LOOP;
      END IF;
      RETURN LOWER(SPELLCODE);
    END;
     else
      begin

  FOR I IN 1 .. NVL(LENGTH(v_lang1), 0) LOOP  
V_COMPARE := lower((SUBSTR(v_lang1, I, 1)));
 if (ASCII(V_COMPARE) between 48 and 57) or
       (ASCII(V_COMPARE) between 65 and 90) or
       (ASCII(V_COMPARE) between 97 and 122) then
      
V_RETURN:=V_RETURN||V_COMPARE;
 ELSIF (ASCII(V_COMPARE) between 33 and 47) or
       (ASCII(V_COMPARE) between 58 and 64) or
       (ASCII(V_COMPARE) between 91 and 95) or
       (ASCII(V_COMPARE) between 123 and 126)
        then
V_RETURN:=V_RETURN||V_COMPARE;
  else 
V_COMPARE := F_NLSSORT(SUBSTR(v_lang1, I, 1));
  IF V_COMPARE >= F_NLSSORT('ß¹') AND V_COMPARE <= F_NLSSORT('òˆ') THEN V_RETURN := V_RETURN || 'a';
    ELSIF v_lang1 = 'ÐÐ' THEN
      V_RETURN := 'h';
    ELSIF V_COMPARE >= F_NLSSORT('°Ë') AND V_COMPARE <= F_NLSSORT('²¾') THEN
      V_RETURN := V_RETURN || 'b';
    ELSIF V_COMPARE >= F_NLSSORT('àê') AND V_COMPARE <= F_NLSSORT('åe') THEN
      V_RETURN := V_RETURN || 'c';
    ELSIF V_COMPARE >= F_NLSSORT('…ö') AND V_COMPARE <= F_NLSSORT('ùz') THEN
      V_RETURN := V_RETURN || 'd';
    ELSIF V_COMPARE >= F_NLSSORT('ŠŠ') AND V_COMPARE <= F_NLSSORT('˜Þ') THEN
      V_RETURN := V_RETURN || 'e';
    ELSIF V_COMPARE >= F_NLSSORT('·¢') AND V_COMPARE <= F_NLSSORT('ªg') THEN
      V_RETURN := V_RETURN || 'f';
    ELSIF V_COMPARE >= F_NLSSORT('ê¸') AND V_COMPARE <= F_NLSSORT('ÄB') THEN
      V_RETURN := V_RETURN || 'g';
    ELSIF V_COMPARE >= F_NLSSORT('Šo') AND V_COMPARE <= F_NLSSORT('‰þ') THEN
      V_RETURN := V_RETURN || 'h';
    ELSIF V_COMPARE >= F_NLSSORT('Ø¢') AND V_COMPARE <= F_NLSSORT('”h') THEN
      V_RETURN := V_RETURN || 'j';
    ELSIF V_COMPARE >= F_NLSSORT('ßÇ') AND V_COMPARE <= F_NLSSORT('·i') THEN
      V_RETURN := V_RETURN || 'k';
    ELSIF V_COMPARE >= F_NLSSORT('À¬') AND V_COMPARE <= F_NLSSORT('”^') THEN
      V_RETURN := V_RETURN || 'l';
    ELSIF V_COMPARE >= F_NLSSORT('‡`') AND V_COMPARE <= F_NLSSORT('—Ò') THEN
      V_RETURN := V_RETURN || 'm';
    ELSIF V_COMPARE >= F_NLSSORT('’‚') AND V_COMPARE <= F_NLSSORT('¯‘') THEN
      V_RETURN := V_RETURN || 'n';
    ELSIF V_COMPARE >= F_NLSSORT('¹p') AND V_COMPARE <= F_NLSSORT('a') THEN
      V_RETURN := V_RETURN || 'o';
    ELSIF V_COMPARE >= F_NLSSORT('Šr') AND V_COMPARE <= F_NLSSORT('ÆØ') THEN
      V_RETURN := V_RETURN || 'p';
    ELSIF V_COMPARE >= F_NLSSORT('Æß') AND V_COMPARE <= F_NLSSORT('Ñd') THEN
      V_RETURN := V_RETURN || 'q';
    ELSIF V_COMPARE >= F_NLSSORT('’') AND V_COMPARE <= F_NLSSORT('úU') THEN
      V_RETURN := V_RETURN || 'r';
    ELSIF V_COMPARE >= F_NLSSORT('Øí') AND V_COMPARE <= F_NLSSORT('ÎR') THEN
      V_RETURN := V_RETURN || 's';
    ELSIF V_COMPARE >= F_NLSSORT('‚@') AND V_COMPARE <= F_NLSSORT('»X') THEN
      V_RETURN := V_RETURN || 't';
    ELSIF V_COMPARE >= F_NLSSORT('ŒÜ') AND V_COMPARE <= F_NLSSORT('úF') THEN
      V_RETURN := V_RETURN || 'w';
    ELSIF V_COMPARE >= F_NLSSORT('Ï¦') AND V_COMPARE <= F_NLSSORT('èR') THEN
      V_RETURN := V_RETURN || 'x';
    ELSIF V_COMPARE >= F_NLSSORT('Ñ¾') AND V_COMPARE <= F_NLSSORT('í') THEN
      V_RETURN := V_RETURN || 'y';
    ELSIF V_COMPARE >= F_NLSSORT('Ž‰') AND V_COMPARE <= F_NLSSORT('…ø') THEN
      V_RETURN := V_RETURN || 'z';
    END IF;
    end if;
  END LOOP;
  RETURN V_RETURN;
END;
end if;
end;
/