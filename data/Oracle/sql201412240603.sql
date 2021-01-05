CREATE OR REPLACE FUNCTION GETPINYIN (PRM_SPELL IN VARCHAR2)
  RETURN VARCHAR2 IS
   V_COMPARE VARCHAR2(100);
  V_RETURN  VARCHAR2(4000);
  a number;
SPELLCODE VARCHAR2(100);
  INSPELL   VARCHAR2(4000);
  V_BITCHAR VARCHAR2(100);
  V_BITNUM  INTEGER;
  V_CHRNUM  INTEGER;
  V_STDSTR  VARCHAR2(100) := '∞≈≤¡¥Ó∂Í∑¢∏¡π˛ª˜-ø¶¿¨¬Ëƒ√≈∂≈æ∆⁄»ª»ˆÀ˙Õ⁄-Õ⁄ŒÙ—π‘—';
  V_CHARA   VARCHAR2(4000) := 'ﬂπÔπÂH‡ƒÔÕÊXﬁﬂ‡»‹t˛H◊cˆ∞Ï\Ì¡‡…Ê»Í”Ë®Ÿå¯è◊rËP˜oÏaËÒ‚÷⁄œ’YÏî÷OÈúıc˘gÌè˘ìÎà€˚ÔßÎ@ﬁÓ‰@·ÌÿtÿÅÂB˜ˆ·l€Í›EÎJ‡ª‚⁄È·Â€÷í˜°˜Èˆó˙q¸Åﬁ÷Ê¡ÈO·ÆÊÒ÷ìˆÀ∆Ò˙Ú¸';
  V_CHARB   VARCHAR2(4000) := '·±ÙŒ·öÿ^˜ÑÙÉ‹ÿ·ó›√›RÔT˜…¸ñÓŸ‚Z⁄ïˆ—ıEÂ±Í˛ﬁ„ﬂ¬ÏãŸîÌvÓCﬁn⁄Ê€‡Ó”Ù≤‚kÙëÈõ„[Ïáﬁk‰∫ﬂôÌD›Ú÷rÊ^ŸËÊﬂÏ“ˆµÈñ˝_›·ÔíÔñ¯R¯dŸÖÏdı¿Ëò„EÏsıUËt⁄È˘l„mÿê⁄˝„£‡f›KÌ’›Ì’R›Ö‰^˜πˆÕÍ⁄ﬂGŸSÔºÂQ€Œ€–›ôÈa‡‘ÏûﬂJ€MÍ¥ÈGÁaÿP˜îÊq˘Sˆs›©ÿ∞ﬂ¡Â˛ÔıŸ¬Ù∞ÿÑ◊ùﬂõÓØﬂŸ‹Í·˘ÓÈÊæ‚ÿ›…È[È]Âˆ„πŸC⁄P‰‰ıœ„GÈsÔè‡äÊ‘ﬁµıIÂ®€ãÌ@˜¬Ëµ‡àÙ≈Á@ÌSÌ{‹K‹LÙx⁄FËE˙z˙á¸ÑÌæÏ‘ﬂÑÊQˆ˝ﬂÖˆbˆcÿ“ŸHÌ‹¯u€Õ‚Ì„Í‹–·äﬁ’Á¬ÈrﬁgÓYﬁlﬁmﬁpﬁq◊ÉÏ·ËºÏ©˜‘ÔRÊÙ˚ÅÔ⁄Ï≠ÏÆÔ[÷ÄŸôÁSÔÔjÔkÔlÔnËsÊª’ïÂl˜ß˜B˜M¸Ç˝ñıøﬂìŸœÁÕÈƒÿhŸeŸfÔŸ·ŸÏEË\Ó†ÈÎÎ˜˜∆˜ﬁÙWŸ˚‰â⁄˚ÍvŸ˜‚ê„uÏèÔûVﬁ’@ımÏh‚ƒ‡£„\G‹@˜Qÿ√‡RŸÒÓ‡‚ì„K˜àı€‰cÈDıNÿmÊn˘PÌÁË}ıÀÙ§Î¢Èﬁ◊LÂÕÓﬂÍŒ‚ò’cJﬁKı≥ﬂ≤¯G˘L˚QÓ–Í≥‚b€Y‡^æÒ£Ò≠Ò—ÒÿÒ€Û˜ÛÎÛŸÛ÷Ú˘ÒŸÒ‘ÒπÒ¶±«';
  V_CHARC   VARCHAR2(4000) := '‡ÍÌÂﬂnÿî€PÔ{ÊÓ˜ı¸oÙ”Ë≤÷çÿ˜˚]˙IËÜŸâ‡–‰ÓÙΩÁ[‹≥‡ì¸è‚¸·Ø‰π‡·Ëæ‚«„òÔ ÂöÊ\‚™ÏxÈ∂Èﬂ€ÇÔÔËd„‚Ê±ÓŒ‚OŸ≠ﬁ{ÍË‰iÊøÂÓÏ¯’S‰a‚‹‰˝‡öÔ‚‡ûıÈK◊ãËÅ⁄∆›€’~ÈàŸÊ·p÷ùÁPÍU◊Ä‚„ÂÒÌ]ÓùÿˆÊΩ›≈„—Ë†Â_ÈãˆˆK¸ç‹…ÈLÈM·‰Êœ‰ñ˜ïÁL˜lÍ∆„ÆÎ©‰ê‚Í€À’kÌo‚˜ÏÃ‚nÍÀ‡}¸ÖﬁC¸{÷ö˚û‹áÌ∫Â¯€ÂﬁäÓJﬁ”Ë°‡¡’ÄŸo÷nﬁçÂ∑Íê⁄»‹ï‚\Îè÷R˚â˙m⁄íÌ◊€{Ÿïˆ≥⁄fÈ¥˝Y˝Z⁄ﬂ◊èÍpËﬂÓı⁄WÏlÓ™⁄XÓdÁdÁpËKÿ©Ë«‡J€ÙÓÒÎÛ’\ı®‰ÖıìﬂÍÌ˜‡ÕÊ ’v¯|˘A˜Œ˝c¸J¸[‹›⁄dŸPﬂW⁄mﬂg‹Øıÿﬂt÷sÙ˘„r˝X·‹ﬂ≥‚¡ﬁåÎ∑‡¥ÔÜŸ—€L„MÎÜﬂo„â⁄Ü˘ê˙u‚Á‹˚Ù©„øÙæ€åÍôÔ•„|Ÿ±‡¸„∞·OÎlˆ≈‹P·~◊á◊â·hÙ{ﬂcÈÀÿå˝i€ªÿa⁄n„I‰zÎrıÈ˙R‹XË∆Ë˙˝s˝Éÿ°‚Á©ÿX‡s€UÈz’ë„¿˜Ìﬁı‡®‡‹ıﬂÁ›Î∞Ù≠Â◊›é‚∂ÓÀ‚AŸi˙EÍJ‚Î˝ó⁄ÔÈ¢È≥ÂNÊmÓq›êˆj˘úÍÅ›ª·cÂTıû˘áŸÉ€wı÷Â¡ﬁuﬂOÍ°·Q⁄}›zˆ∫˝pËq˝wﬂ⁄⁄eÏÙ‹Îﬁe‚ëÙŸﬁiÔì@¯yﬁo˙\˙]⁄ùŸn‹ Ë»ÊıËÆÁW‰»Á˝’pŸzŸ{÷ÅÈ®ÎÌÍ£›è˚Ä˚Ç˚õ·ﬁÈ„‚ßı°›˝’K⁄u€qıæ¸yıÌ‹AÓïŸ‡ﬂ•ÔÈ‹fËâÏ‡È¡ÁJË≠⁄~ﬂ˝„≤›ÕÎ•Óxﬂó€Z‚‚ﬂuı„·i·œÔÛı∫˚z˝ÄÎ‚ÿ»ﬂHÔ±‰SÂeÂ§˚ˆøÛ¯Û◊ÚøÚ≤ÒÈÒÂÒ›Ò“ÒŒÒ√Ò¨Û∏Û©Û§ÚÌÚ‹Ú…Ò°Ó∑ÊˆÀ»Î˙';
  V_CHARD   VARCHAR2(4000) := 'ﬂ’ﬁ«‡™ÊpﬁÖﬁáÊß‚ÚÌ≥ﬂQﬂ_€Q˜∞˜≤Ê]‹JËNÌ^˝ë˝ìﬂæﬁa·∑ﬂ∞Á™Â ÁÈ‹ç‹§‹ñŸJ›Dı\¯l˜Ï€êÏO¸nÏ^ÌÒ‹l·GÈÈ‡êÓFŸŸ¸^‡¢›Ã’QÂ£¯}ŸúÏK⁄‘◊[¸h◊ï€ Â¥Ì∏›–ﬂTÎã⁄ÅÍWÿ÷ﬂ∂‚·ÎÆ·í˜ÅÙÄÍâ˛OÎIÎZÏ‚‹ÑÙÓÔΩÂuÿO‡‚Ù£Í≠‡áÎQ·ÿÌ„ÔÎÁãÙ∆Íù⁄h‡÷Ô·Â~ÌLÁCŸ·›∂ÍÎÏ{ÓEÙÜÿp˚Mÿµ⁄Æ€°Ís€ÊË‹Ì∆›B˜æˆWÊ∑ﬁû⁄–‚KÈ¶Ì˚ﬂf„dÌ⁄ﬂr÷B€y‡«€Ü·€ÓåÓç˝Çı⁄¸c⁄Á€„ÁËÓ‰‚öÎäÙ°ıı¯JıMˆÙ¸óı†˘m·ûÓˆ‚y‰HÎç’{‰îËS€Ï‡©‹¶ﬁÈ⁄gÎ∫ÈP’ôıﬁˆ¯ˆlÿÍÁ‡Ù˙·îÏwÌî¸áÁñÔ}‡§ÎÎÌ÷ÂVÓrÓ˚ÔM‰AﬂÀ·¥Î±ı[¸äˆC˘Ö˙H’â€Ì·ºÎÀﬁìÎÿÌœÎö›˙ÍhÓ◊˛K‚^‡KÙY·HÈkÙZ‰WLÍLÙ^Ù`ÙaÍ^‡Ω·`ÍA‰¬Ë¸Îπ’iÂL˜Ú◊xÿK⁄GÌ~˜«ËoÌbÌÅ¸t◊òŸÄ‹∂Ï|ÂÉÊHÈ≤Ï—Âë‹YÓX¯ãÁéÌ°ÍåÍ†Ì‘Ì≠ÔÊ◊BÁÖ◊mÌ‚‹HÌÔıª‹O„ÁÏ¿Ìªﬁö‚gÓDﬂq€vﬂÕÓÏ‚áı‚ıyËIﬂ·Á∂⁄r‹o‹ÄÙD„ıÍwÍy€F€GÔò˘z¨Û˝Û˚ÛÏÚΩÒıÒÙÒÛÒ◊Ò÷Ò…ÒºÒ≤Ò∞˜ÛŒÛ∆Ûº„€¥';
  V_CHARE   VARCHAR2(4000) := 'ÂÌﬁà›≠‚eÔ∞’M‰~ÓPÙâÓ~˘Z˘[◊FÊπ˘EÍiﬂ¿‹√ÍqÈÓ€—⁄Ã‹ó„’„µ›‡ÿ`›Qﬂ]ÎÒÔ…ﬂ{ÓOIÿ¨÷@ÈëÂäˆ˘ÓÄˆt˘ò◊ÜËy˝|˜{›ÏﬁÙÌEÍz›[ˆ‹ÎXıb¯çﬁWÂ«ÁÌÓÔ„sDﬂÉ⁄çŸ¶Ÿ@ŸEπÚ¶ ';
  V_CHARF   VARCHAR2(4000) := '·e€“ÈyÌ¿Âz·¶ﬁNÔcÔx˜Y‚Cﬁ¨Ï‹ıÏﬁ¿Áx˙ãﬁxÓ≤‹èËÛÿú›GÔàÔâÿŒ⁄˙Ë Ó’⁄ì‚[Âp¯hˆ–Ùô·›Ù≥˙JÂ˙ÔwÁ≥ÏÈÏqˆ≠ˆÓˆEÔy‰«ÎË„≠Ï≥ÈºÙ‰’u·ÙŸMÔ–¸îÁöÏ]Á„‹m‚pÎÉË˚ÎVÙö¯Xÿk˜˜¸ãÿrﬁMËM¸R¸vŸ«ˆ˜ÂØ˜a„„ÌøÔL›◊‡ï‰hÿSÊëÁQ€∫ÏbÔp¸KﬂÙ÷SŸ∫⁄R¯L¯P¯iŸàÎÄ¯]ﬂëﬂªı√·KÙÔÔ˚ı∆‚a‡~ÿf¯W˚ü¸A¸FŸÏÊ⁄‹Ω‹¿‚ˆÁ¶Á®‹ﬁÏÓ∑‹Ú€ÆÌÇ¯IÌ…›≥ŸÎËıÂı› ˛E„R„VÔO¯DÌh·•¯q÷D€~›óıHıvÌÍ˘f˘õﬂºﬁ‘‡M·ú‰Ê›oÙfÌÎ⁄‚Ê‚ÿìÍÇˆ÷ÍÁŸx›ïıVŸéÂáÂòˆ˚ˆv•ÛıÚ∂Ú„ÚÛæÚÛÚ›Ú';
  V_CHARG   VARCHAR2(4000) := 'Í∏Ÿ§Ó≈ÊŸ·èÂmÊÿﬁŒÙp‡@⁄Î€ÚÍ‡ÎBÿdŸWŸ^ÊYÿ§‚}ÍÆﬁ|€·„Ô‹’Ù˚ﬁœ¯NÙv˝û‰˜⁄sÈœﬂ¶˜†˜hÍ∫Ì∑Á§‰∆⁄MÍlÓ∏‚G‰ìÊsÌ∞È¿ÿ∫Ìz˙k¸é˙èÍΩÁ…È¬ﬁªÊÄ⁄æ€¨ÔØ’a‰Ü€ŸÊ¸Èx¯m¯w÷g¯ùÊäÿ™‡√‹™Î°ÎıÈwÔ”ÏëÌk˜¿÷Y›ëısÊkÌuﬁPÌRˆè€¡Ù¥Ì—„tﬂÁÿ®Ùﬁ›¢‚Ÿ˚fŸs˘à‡QﬂÏÁÆˆ·ıÜÎ≈ˆ°‹p˝ä˝èﬁ√ÁÓ›\Ïñÿï⁄Cÿ˛Á√‚h„^˜∏Ìx·∏Ë€ÿx⁄∏Ê≈Ï∞Â‹ÎgÍÌŸèÈÔ›‘ı˝›L›MÙ˛Ï±‚çıY¯Å›û˜Ω˙X„È⁄¨ÍÙÓπﬂEÓ‹‚í¸âÿ≈Î˚Ó≠˘]·ƒËÙÍˆÔ¿ÌùÂdˆÒˆAÓôÎ“ÔN⁄o‰TÔW¯éﬂ…ÿ‘⁄¥ŸƒÈvÍK˜§ÍPˆä˜b›ÑÂ]‹I¯AﬁË‰ ÿûﬂkÓ¬ÎqÊöËÖ˚X˜}ﬂ€ËÊÎ◊›_„†¸U·ÓÊ£ﬂû‡FÈ|ˆŸıq˝îÙhÙk˛IÂ≥‚—ÿ–Í{‹âÍ–ÿ€Í¡ŸF˜¨ÌW˜Z˜iÿ≠ŸÚÁµÌﬁ›ÅˆÁıPıÖ÷èﬂ√€ˆ·∆‚uÂÅ‡˛ﬁ‚ÎΩŸÂ‚£È§›{RËJﬂ^Û˛ÛÙÛ‡Û—ÚÂÚ‰Ú¡ÚºÚ¥Ò¯ÒÊÒÀ·Ÿ¿Ûª≥ß';
  V_CHARH   VARCHAR2(4000) := 'Ó˛„x‡ÀÎ‹·Vı∞ÔôÌôÿEıA˜˝⁄ıÍœÏ ‰wÌnÿJÙ_Í\›’‚FÈ\ﬁ˛‰I‰dÓhÓu÷õÎnÂ´˙[ÙåﬁÜÁ¨ÿòÓ@„Ï›Ô‡„ﬁ∂‡∆Â©◊qÍªÂ∞ÓóˆÇ⁄≠‡¿€¿‡AÍ¬Ó¡˝ÜÿÄ„F„ÿ˜ÖÈu˚i˚ùÓMÙÁÙüÍHÌH˝[˘üËY˝òÎaŸR€÷˙Q˝LÏeÏf˚SÏg¸\ÏïËÏÁÒ˚a¯í˘CﬁøËUŸÍ‹üÿFﬁ∞›ìÂùﬁZ„»„¸›¶ÿA‚vÈbÿD„pÏçÙÑ‰fﬁÆÎîŸ‰Îü¯ô¸Z⁄ßÈ{‰UÈïÈóÙ\˝J„êÙ◊˜øÊAˆ\‡C··ÂÀ‡j‹©ÿ_ˆ◊˜çı`˜cÏ√Èıﬂ¸„±‹†Îå‰ÔÎi÷ó‡Òı˙‚©ÏŒÈŒÙñı≠ÓgÏ≤ÊLÙEˆ{˘ñ˙C˙K‰∞Á˙ÂtˆUŸ¸·≤‚ÔÏÊÏÔÏË‡Ç¯UÂè◊o˜üÌ_Ìí˜s˚I’jÂkÊËÓ¸‰n÷úÁf˙ÜËÎ’ñ’†¸Xı◊¯b˘J‡†‚µÿé◊í€®‰°›»Îfÿ}ÔÃÍaÂæÁŸﬂÄÿoÊDÈI˚qﬁSÍXËG˜ﬂ›k€º‰ΩÂ’‰ÒˆÈﬂßıåˆZˆdÎ¡⁄Ú¸S·Â‰“Âÿ‰ÍÈBË´÷WÂñˆ¸⁄áÌãÁuˆm˜U˙ä÷eÊw⁄∂ﬂ‘ÍÕÁıÿYÎD›x˜‚„ƒˆô‰ß‹ÓﬁíﬂDıt◊eﬂ‹‰´‹ˆÌ£ËÌÂÁ‡πÁ¿Í_ŸV’dﬁ•÷MÓ_◊M◊fÁiÍTÁûÏuÌ}◊wÓú„‘Èí‚∆QﬁF˝@⁄ª‰„’üÔ¡ÿÂÂxﬂ´ﬂòÓÿ‚Ä‚∑ÈXÿõ˛A÷fÎoÔÏ‡ÎﬁΩËZÏ[©ÛÛÛÚÚ∫Ú≥Ú´Ú•Ú¢Ò˛Ò¸ÒÎÒ•ÛÀÛ∂Û≥Û®Ú¬Ú¿˙◊…≠';
  V_CHARJ   VARCHAR2(4000) := 'ÿ¢ﬂ¥ÿ¿Á·‹∏Ì∂ﬂ“ÿﬁﬂÛÂÏÔ|Ô˙Í˜ÍÂı“¯K„ÇÁ‹Ÿ}‹uÏ¥€‘ÂZÎYÓøŸä‡úÎu◊IÌá˘ç◊^Áà‹QÌZ˙a˝VËWËi˝W˚A·ßÿΩŸ•‡B˛LÿCÍ´ÈÍÈÆ›⁄l„öﬁ™€eÏì˚n›ã€àÂâﬁUÁgÏP˙W˙n‹eÎ|Î}ﬁ·˜ÇÍ™·’˜‰ÙáÂÊ‹¡ﬂ‚‰©ÍÈŸ €EÎHÙﬂ’Hı’ˆ´ˆ›’ÇˆÍ˜ŸıJ€îˆa˘H˝TÊ˜ıü˜DÏVˆõ˜C˜qÂ»‰§ÁÏÙ¬›Áı „eÔÿÿjÿÜÊâ˚ì·µ€£‡PÌ¢Í©ÓÚ€OÔù‰eÓ]Óa¯î˘GÎŒŸZ‚õÍß›—ÿ]‰’Í˘ÈgÏyﬁˆÁÃ›Ûÿbˆ‰¯Z‰íÌK˚Ö˜µ˜ú˘pˆx◊tˆÅ˙YÌ[ˆûË~Ìd‡ÓË≈ı¬Ì˙Ôµ⁄ŸÍØÙÂÂ¿Âø÷àÙCˆr˚xÁâÁô˚{◊v˚|Í⁄…‚VÈ•Î¶ÎÏ⁄ôÈfŸ`Ÿ‘’êŸv⁄{€`ı›÷GÊITÊGÁZﬁYËaËbË{ËÉ‹¸Ù¯Á÷˜öÌ‰Ì\˜F÷vÓé‰ÆÁ≠ÍÒ·nÙ›·u÷ò‹¥ÊØ‹˙ı”Ÿ’ˆﬁıo¯üﬁBÁÄ˙Ñ˙åŸÆﬁÿ‰–Î∏Ÿ]€]„qÔú·Ë˘a◊K˜R·Ω›^‡›⁄äﬁIı¥◊_·ÜÎA‡Æ‡µÏå˘ô⁄‡Ê›⁄¶⁄µﬁ◊ﬁóËÓÊº„]ÙÇÌŸˆ⁄Ù…’m€dÓRÊOı^Ôê˜∫’]ÙèÓƒ·é˚v¸T⁄·›¿‚€‚ÀÈ»Ë™Â\÷îÊ°›£Í·ﬂMÁ∆ÍÓ‡‰ŸÅ⁄B˝Ñ„˛Ï∫›ºÎÊ˘XˆL˘~˘Ç˚è¸†˚ó⁄ÂÿŸÎ¬Ÿ”„ΩÓiÂÚÂ…Î÷ﬁüÊ∫ˆ¶‚∞’e€VÓKÏnÏoÁRÿÁÏÁÂƒﬁõÔGÓyÙÒ„Œ‡±¯F˜›ÙbÈNÌÉË—ËÍŸ÷ˆJ˚ç˝n˙ê‹⁄Íèﬁ‰ÈßË¢ÙÚ⁄†Ô∏ˆ¬’á€g‰|ıL¯~˜∂˘â‡`›]€R⁄z‹vÈÖÈŸ˘V€û˘q˙G¸ü˝A‹ÏÈ∑È∞ˆ¥˛Fı·˝e⁄™‹ƒﬂöÓ“Ÿ∆Í¯€B‚†Ï´ÿeÂıXÂ·‰èÔZˆƒÿã‹Mı∂ËL‰∏‰g‰mÔ‘Êå˘NÁùÓ√Ô√‰üË·˙ˆ¡€≤ÎhÔÖC‡ŸÊﬁÁÂ·»Ëˆı˚⁄b⁄ëﬂIÿ ⁄k‚fÿ„⁄‹‚±ﬁß¯_¯`‡ÂÈ”ÈQÔ„◊HıÍ‹B˘ä€«Á~ÁèÏﬂ˙Ä˝ôÿè‹jËë‹ä‚x„z„ó˜ê˜ÂÂãız˚ä˚éÍ}ﬁ‹K˘Q˘R˘U¢œ‹˝ÛﬁÛ≈Ú‘ÚÃÚªÚ±Ú°Ò‰Ò’Ò–Ò Ò∆Ò¿Ò§Ë’Û’Û»Û«Ò‘Ø®';
  V_CHARK   VARCHAR2(4000) := 'ﬂ«ÿ˚ÎÃ„lÔ¥È_Áòÿ‹€Ó‚˝Í]Ó¯›‹›aÔ«Â|ÊzÍGÔa‚ÈÊbÌËÍ¨˝êŸ©›®›|›ùÓÉﬁR„€Ó´ÍR‹{Á_˜Kÿ¯ﬂí„ Ó÷‚ÇÈ`ÂÍË‡ÓÌÍ˚‰D˜äıwıëÁÊÈ⁄êÓ››VÔ˝‚éÓßÓW·fÓw˜¡·≥„°Î¥ÊÏÁº‡æ‰€Ôæ’n‰òÿcÿ~ÂoÔ¨’U‰LÂîÁHŸ≈·«‹w‹xÂI˘yÏù‹“ÌÓﬂµ‚@ﬁ¢˙dÿ⁄ﬂ†‹•⁄ú˜ºıpÁ´‡∑’FŸ®„íÿ·€¶ﬂ‡·ˆÎ⁄˜é‡î˜d˜≈Ëw⁄≤ﬂùﬂ—’E›H⁄ø‹í‹ú’N˘\ﬁ≈⁄˜€€Ê˛Í‹ŸL›A„k‰q‡ó¸YËk„¶ÍNÓèÂ”‡kÌñÿ∏‡≠ﬁÒÍ“Ó•Ó`ÂûÊKŸÁ‹iıÕÌü€ìÿ—‡∞„¥›ﬁ÷dÁqË^Á˚Ôø˜’˚dı´ÂKˆÔˆH˘{˙A„ß„ÕÈÄÈçËÈÓSÈüÌAÌpÏHÌTÙU‚Ú“ÛÒÛÌÛÿÚÚÚÒÚ§ÒÃÒΩÒ˘';
  V_CHARL   VARCHAR2(4000) := 'ÂÂÍπÌ«ÿ›ﬁhÙFÈJˆ_ËnÌB·¡·‚‰µ‡[ﬂFÔ™ÂnˆD˘Ñ¸HÍ„Ì˘Ÿl‰˛ŸáÓmÓs˘`Ù•·∞ÏµÔÁÍ@◊E◊é‹_Ë|ËîÌeÈ≠‰ÌÓΩ·Y‡•˝ú‡O›πÔ¸Ô∂‡H‹q‰ZÊÉ„œ’LÈÅ›ıﬂÎ·¿Ô©ı≤ÁÑÓëË·ÓÓ„ôıuﬁL‹~ÿÏÍbﬂ∑„ÓÌâ˜¶ˆòEÊ–Á–È€Ÿ˙ËDﬁ[ËhÏY˜m˝F⁄≥’C◊|Ëà˚Pı™„ÅÓLÓ[ÂGÔKÓê‡œ‹®€k„∂ÊÍ‡¨Á ›ÒÊÀÿÇ‰Çˆ‚Óæ‰ú÷Ç·rﬁºﬂÜ·çÎxıîÁ\ˆP˘v˜ÛËg˜~˚Z˛GŸµÊ≤ÂŒÔÆÿN˝ü‰áÂ¢ıéı∑˜Øﬂä˜kﬂø€ﬁ‹¬ÏÂË¿Ÿ≥Ë›⁄\Èˆ€™·˚Ì¬›∞‡¶ÙœÓ∫ı»ˆ®‰‡„W¯EÎ_¯tÎ`˚ê·B˙b˚ï‹Vﬁ]◊Åﬁ^ÏZ˜uÏcﬁ∆ﬂBˆ„Â•Ï°€ö÷ãÊ`◊`ÙHÁ†ˆñÁˆ›¸‡òÊÆÈÁÈ¨‰ÚÂbÂÄÊúˆn˝ùÈ£ﬁc‹Æı‘›à˜ÀÙu›g’è›vÂy‹G‡⁄Âº‚≤Á‘ﬂ|ÿIŸí€éÁÇÔm˙çÓ…·ë‡Äﬁ§ÈRﬁÕﬂ÷Ÿ˝‰£ﬁò€¯ﬁÊÙÛÔVıh¯ïıÒÙQ˜‡˜vﬂ¯Ù‘‡èÎO˝†·◊Â‡Í•Ó¨˚ãﬁOÁl˜Î˜[‚ﬁ„¡È›ÔCŸU›˛Ï¢Èä‹CıÔ‹\‹kﬁ`‡Ú„ˆ‹ﬂË⁄Í≤˚_Ë˘Á±Ù·⁄ö›C‚èÈq›sÎë‰ôÎôıCˆÏ¯o˚wÎùÎû˝h€πˆN˝g·ÅÏ`˚ô˝íÍtÓIﬂ Ï÷‰ØÏºÂﬁÊÚÔvÔ÷˚mÈHˆÃÊy˚àÁBÔdÁsÔiˆÜ˙VÁ∏Ô≥‰ç€âÏCÎwÔfÙj˙w„Ò‹◊Ë–ÁÁÎ Ì√˝àÁXÏN˝ç˝éÿL‹[ËxÏ_˚T€‚Î]⁄LŸÕ‡∂›‰ﬂs÷å‹}˜√ÌV·–ÔŒÁU‡‡ﬂ£€‰„ÚË”ÎÕÈÒÙµ‚Ñˆ‘Ùóﬁ_ËzÔB˜|˚R¸u˚uÙîÈ÷ÔÂÊîÁúËuÈ˚Íë‰ÀÂ÷ŸT›`‰ı⁄Ä€jÍ§·X‰õÂhÂjË¥¯ö€çﬁAÁGˆI˘c˘nÁe˙òÎ™„ÃÈµÈÇ˙y‡LÔ˘Îˆ‰XËrËÔŸıˆ«˘FËé˚[·õÔ≤‰s‰x‡Íç€i›Ü‰óˆM’ìﬁ€Ób‚§Î·È°Ô›Ê†ﬂâ˙üËåŸ¿‹sŸ˘„¯‹˝ÁÛﬁ˚‰ˆ√ıiµ”Û¸ÛˆÛ“ÛªÛπÚ˜ÚÎÚ€Ú»Ú√ÒˆÒÆÒ™Òß¸¯Ïﬂ›ÿ“ΩÒÔÒÏÒÁÒ‹Ò⁄ÒœÒÕø';
  V_CHARM   VARCHAR2(4000) := 'Ê÷·ÔﬂjÊã˙iˆáËøÈUﬂÈÙKˆ≤›§ŸI˙î€Ω˚úŸuﬂ~Ï@ÏAÓî˜¥˜©ÙMÙNˆ†Êû‡Ñ‹¨·£ÁœÏ◊Ô‹÷ôÁN⁄¯ÌÀ‚IËö‰Ä‰›ÿàÍÛÏ∏‹ö·F˜÷Â^˘ö·π„˜‹‚Íƒ„TÎ£ŸÛŸQ‡|Ë£Ó¶‡éÌÆ›Æ‡d·“‰ÿ‚≠ÈπÔ—‰YÊ[˙B¸q‰º‹zÊV¸e⁄õÙmÌi˜»ﬁ—ÓÕÈTÈYÂ{ÏÀÌØÎâ›˘ﬁ´‡ë‡ñÎ¸ÌÊıíÙø˚sÏXÓü˚L€¬ÙªÂi„¬ˆQ¸ÄÏDÏW€_ﬂ‰ÏÚ‚®÷i˜„˚Ü˜Á˚îﬁ¬ÈS·Ç·É˚J·àÿ¬ÂÙÙÕÎﬂ„ù⁄¢ÙÈ„ËÂµ⁄◊‡◊¸Ü÷kÂ≤„ÊˆºÌÌ‰œÎÔı|Ïr˚†¸@¸M¸Iﬂ˜˘ë˜]Ë¬ÌÌµÁøÂ„ÿøﬂ„¯pËf˜x·∫Á‰‹ÂÁÎÁ≈‚åŸÇ‰†¯sÊF„…„˝ÈhÌ™¸wÈ}˜™ˆö‹¯⁄§‡p‰ÈÍ‘„ë¯QÓ®ı§Á—÷á⁄”Ê∆‚…¸N˜·Ùû÷É÷Ñ◊O¸OÈ‚‹‘Ô˜ÿ{›Îıˆ„ÄÏÖÔ“Ùé¸aı¯ÊüﬂËŸ∞Ì¯„w÷\ˆ ¯ú¸EÎ§„a€[ÿÔ„Â€È‹ŸÓ‚ÎÇ„fÎéÌJ≈Ò«ÃÛ∑Û±Û°Ú˛Ú˝Ú˙ÚÏÚ÷ÚµÛ˙Û∫Ú©ÒÚÒ¢';
  V_CHARN   VARCHAR2(4000) := '’yÔ’ÊìÎ~Î«ﬁ‡ÿv‹òÿy‚cÏÑÙõ‹µﬁï·ùËÕ›¡ÿæÂr‡Ô‡´ﬂaÈ™÷QÎyÙˆÎÓ‡ÏÙT‚ŒÍŸﬂ≠˝Qÿ´ﬂŒÌ–ÓÛ‚Æ◊DÁt€ÒËßÈmÙ[⁄´HıÉıù‡≈‚Ö‰G€Ë‚ı‡\ÓÍ‚•€C‚âÿÉ›rˆÚˆF˚å˝uŸ£Ïª„bÎWËXﬁãÍ«Ì˛ˆ”ıRˆÛ˘DˆTÈ˝›Ç€ú‹Tÿ•€˛·|·Ñ‹‡Ù¡¯BÊ’ÎÂÌ±⁄ÌÙ´Íü‡ø„c€W€f€hÂRıÊÊáÍEﬁ¡˝m◊ë‹bËáÔDËêﬂÃË_ÙV˚Hÿ˙Â∏Ê§‚Ó·‚oÏÅŸØﬂÊﬁrﬁs·x˝P◊aÊeÁê◊kÊ€ÊÂÂÛÊ¿Óœ‚SÌ§Ù¨¸Q‡GŸ–ﬂˆﬂSﬁ˘Ôª÷Z€ÅÂü§Ú®Ò˜ÒÒÒƒÚÔÚÕ';
  V_CHARO   VARCHAR2(4000) := '‡ﬁÌM⁄©Í±¯k÷éÊñ˙t˝{‚ÊÒÓ';
  V_CHARP   VARCHAR2(4000) := '›‚ËÀŸΩ›áﬂﬂ›ÂÊW„›€AıÁ€òÊoÌQ„˙ÓG‰É˘bËãÎÑ‰ËÏQÂÃ˜õ˝â˝ãˆÑÎ„‚“·ÛﬁÀ›NÏé˚É¸Bı¨ÍkÍäÔ¬Ÿr‰û‡˙Ï∑‡Œˆ¨ﬁ\‰‘‚Ò›JÈo‡ÿ‹°›~ÂAÌäÌé˘iÙJËm€sÍCÿßÁ¢⁄¸ÓÎÿw‚W‚t‚î„Y„ç‡Ë‰öÂCıBÍVÍo‹≈Ë¡€Ø⁄€˝ÿu˜âÓºÎRÙìıQı˘˘d‹±‚œÿÚ€‹„õ’|¯aﬂ®‰ƒÊ«Ó¢Í∂˙ù˚GÍ˙ÙÊ˙@ÊÈÎ›ŸX’óı‰⁄“ŸG’õÙùÿ‚ÁŒÔgÔhÙwÍQÈËÓ©·oÓí‡—ÊŒÎ≠ÿØ‹÷ÁvÊ∞ÿöÊ…ÓlÔAÈØÍÚÊ≥Ÿ∑ÓZ‡ZË“›Zˆ“›ÉıGÓ«·ï·N·wÁk€∂÷cÿœÓﬁ„OÁÍÓHÔHﬁÂŸˆÍ∑Î∂ÍÜ‡€‰ÅıãŸÈ·TË±ÂßÔ‰ŸüÁh‰ﬂÎ´÷EÔË◊VıÎÁí´Ò‚Ò·Û¶Û≤Û·ÛÕÛ¥Û™ÚÁÚ∑Ú≠Ò»Ò±Â';
  V_CHARQ   VARCHAR2(4000) := 'ﬁÄËÁ‡V›¬‡“È ’É€p÷[ÎíıËÙtÁK˘Üÿ¡€ﬂ·™‹ŒÍ»‰ø›Ω⁄ñ‹ô‚HÊÎÁ˘Á˜Ï˜˛DËüÌ†ÙnÙoÙÎ˝Rﬁ≠€aÂW˜í˜¢ıö˘u˘}˜ËÙGÙyˆí˚òﬂå·®‹ªËΩÿMÁ≤ÙÏ÷HÍM„‡‹˘››Ì”Ì¨›÷⁄û·MÏó˜ƒ⁄‰‹∑Ÿ›·©„•ÿ@‚T‚`ÎeÌ©„UÂπ˚eÂ∫’çﬂwÂΩ÷tÓvÁc˘kËBÙRÙSÌa›°Ó‘ﬁÁ‹ù‚j„@„Q‰EÂXÊZ¸bˆë€…Î…„ªÁ◊◊lËc‹Õ‹ÁŸªË˝›Ä„ﬁÍ®ıƒÔ∫Ôœ‰ù€ÑÔÍ€ñÊjÁIÁjÊÕÈ…÷mÙ«Ï¡ÌÕ‡b‡zıŒ‡É‡Öÿ‰€^ÓNÁÿÂ†Ê@⁄â‹E‹FËA‹Ò⁄€„æ˜≥È‘◊S⁄àÁyÌXÓò·†„∏⁄ΩÍ~’VÌmÌI‹NÊ™Í¸„´Ô∆Ùä€oÂõˆ@ÁÉÙ¿’WÓzıÅ‹À‚sÎd‡∫‰⁄ÏÄ‡ﬂ¯VÈ’⁄_⁄cÔ∑‰uﬂƒﬁÏÏi‡W‡ı›X›pˆÎıõË[È—˜Ù‹‹Ìï’àˆ•ÏmÌ‡ıºˆ∆⁄ˆ‹‰⁄^È±˚j⁄Çˆ˙ÌFÌGˆpˆq˘î˜G˝ï·ÏŸ¥ﬁùÂœ·ñÍ‰‚U€œÂŸÙ√Ÿg‰M·bıF˜¸ıâ˘j˜AÙ‹·´⁄∞ÍrÏÓ’o¸Lı@⁄Ö¸D‹|Ù˜Òˆù˜O€æÎ‘›@ﬁ°Ì·¯zË≥¸öﬁæÎ¨·È‹dËä˚Y˝xﬁë‡T„÷ÍÔÈâ¸CÈò¸z„™Áz⁄π‹ıÈ˙Ó˝€I›b„å€mÍB˜ô˜‹ˆe˝jÔE·ÎÓ∞ÁπÌjÌ®„◊„⁄⁄|È†ÍI˘oÂ“∂Ú¯ÚÈÚ‡ÚﬂÚﬁÚ”Ú–ÚÀÚ«ÛÈÛÊÛ‰Û‹ÛÃÛ¿ÛΩÚ˚Ú∞ÚØÒ˝Ò˚ÒﬂÒ∑Ò≥';
  V_CHARR   VARCHAR2(4000) := '˜◊‹€Ï¸‹`ÙX◊j◊å‹ÈË„Ê¨ÎNﬂvÿÈ‚mÙÅ„Ö¯û‹ÛÔ˛‹rÿ◊öÈÌ‚øÌ•‹ê›ÿÏzÏ~ÌgÔÉ’JÔöﬁwÍó‚J‚~Î¿·ı·…È≈ÈFÊg›PÙ€ıÂ›äÂà˜∑ˆk˘íÌqﬂèÔ®„ú¯n‡ÈÂ¶ﬁ∏¯õ·}Óû˜p‡rﬁz‰≤‰·Á»›Í¯MÎ√‹õ›âﬁ®‹«ËƒÓ£‰J‰ÑÈcÈtŸº‡eˆ}ˆî˙U¶ÛËÚÓÚ≈Ú∏Ú¨Ò≈Ò‡';
  V_CHARS   VARCHAR2(4000) := 'ÿÌÏÉÿ¶ËïÏ™Î€‚lÎMÔS‡ÁÓ|ˆwŸêÎßÙLÙ÷‚ÃÁDÈdﬁ˙ÌﬂÊrÓãÁ“Î˝ˆ˛ÔbˆÖ˜f‹£ÿƒÔ§ÎÅ‰CﬁQÁm÷†ÔoÙOÈ~Ô°ÙƒÙãˆËÈåÊ|ıèıêﬂ˛Ï¶ÈÑˆÆ·Íﬂç‹œÊ©ÓÃ€ÔÙÆ‹ë·üÈ^ı«‰˙Î˛ıäÍÑÈW⁄®ÿﬂ⁄]„àÊÛ€∑Ê”÷b◊iŸ†Áó˜≠˜W˜XÈ‰ı¸Ïÿ÷ÖÙl€ŸpËlÁ¥Ùπ›iÔYı}‹Ê€ø‰˚‚¶Ó¥›fŸdŸhŸ‹ÿ«‰‹Ìs˜Í⁄∑˜ìıò˘_ˆYˆü„hˆïﬂïﬂ”ÔÚ⁄≈◊ü‰…’îÓTÙê◊}ÎœÈ©‰vÍjÍÖÍí˛J„HÂï¸õ˘|‰≈◊W˜jÌÚÍ…ŸK·”Ÿãﬂü˚\‚P›È„Aıß¯O¯[ˆıÂúˆXˆâ˙P·á‚ªﬁyÔzÏ¬€ı›™ﬂY„J„vˆÂıZ¸ú◊R¸ùˆàıπ‚ùÏÍÍ€È¯ÓÊ·ãﬂ±⁄÷ŸB›Y‚ã‚ûÔóﬂm‰K’ú’ûﬂ}S÷u·åˆ|˝aﬁ–Ùº·˜Á∑ÊùÏØÁ£ÍxÊ≠Ÿø›ƒ‹ì‡gﬁÛÎ®€S€\›îı_˘eÔ¯€”⁄H¸ì˜n˙û˜t„ÎÚ„_‰¯ÿQÂfÁT˘é˘è‡ß’X„≈ÈV‰Ã˛BÎpÊ◊˙{˚t˚UÁ`’l„ﬂÈjÌòÙB’f’hÂ˘ÓÂ‡ ﬁ˜›ÙÈ√ÊlËp€ÃÊ˘ﬂ–Á¡„jÔtÿÀ‰FÔ»‰˘‰lÊJÔ\Ár˙É˝D„·ŸÓÊ¶ÏÎ„ÙÊ·ŸπÔ~‚Lÿ|‚ñÔï‚Ï⁄°·¬‰¡›ø·‘„§Ìû’bÊç‡n‡≤‰—‚»Ï¨ÔÀ·gÊ}Ô`€≈‡’Ó§ﬁ¥ˆ’ıáŸÌ‰≥⁄’‡º„∫ﬂi˚h›¯ˆ¢⁄xﬂp‰_M÷q€ë˜T˙â‚°›¥ÌıÓ°Â°ÏöÎmﬂUÎS⁄«’rŸwÏ›Â‰Áw◊\Áõ·¯›•‚∏Ôäˆ¿ÈæÊ{˙ZÊ∂Í˝Ë¯Ì¸‡¬Ù»⁄tıÄﬂÔÊaÊiÊèÊêÊïﬂC£∏ﬁÛﬂÛ”ÛœÛ¬ÛµÛ∞ÛßÚÙÚŸÛ˘Û‚Ú◊ÚœÚ™ÒÍÒµ˛';
  V_CHART   VARCHAR2(4000) := 'ı¡ÓË‰‚„B‹Dı]˜£ˆç„ÀﬂeÂ›Í`ÈΩ’wÂJÏüÍFÌOÍY◊n‹cÊÊ€¢Ï∆ıÃˆÿÔUıTﬁ∑ÎƒÓ—‚ÅÿùÍº€∞Ôƒ’Ñ·]ÂUÓt◊Tÿç·v◊Z˙ÇÏ˛Ó„„g·aÍÊŸyÔ¶Ù Ô€€èÁMÁ|ÌU¸ë‚º‡o‰ÁÎGË©ÈÃ€}⁄Zı±ÊhÍO˙S‡˚ŸŒÈEÊÜËíË∫Ôë÷zÌNÌw˜“ﬁè‰¨ﬂ˚Ïä·[Ïí‰ïÂcÿªÏ˝ﬂØÿñÔ´Ì´‰à¸íÎ¯ﬂÇ÷`ˆåÏL‰R˙e˙fÁ∞ÁæﬂX⁄ÑıÆ÷p€áÂç˜ñ¯òÓ}ı{˘Yˆ[˘ï˘ó‹n‹ÉŸ√„©Â—ﬂPÁë⁄å·LÏj¸VÏpÓ±„Ÿ¯âÍD˙c˙l„√ÈÂÔõŸqÂ`Ïtﬁ›Ÿ¨Ïˆˆ∂‰pÏõ˜ÿˆÊıçÊx˝fˆú’AÙ–Ô¢⁄qÓ\›∆ŸN€@‚ü„é¯áÁìÁîËFÔî˜—ÓÆÏòﬂã‹Ê√›„ÈÉˆ™÷F¸ûËËÓ˙ÔF’P‰bÓc‡ÃŸ⁄Ÿ°‹ÌÌ≈⁄U„PŸ◊„n„~Ô†˜ã‰¸ıj‚˙ÊBŸÔ˜ªÓ^¸W‰å˘W˝C›±‚ä€Tı©ÂÑ˘I˘ù˙h˙ìÓ ‚QﬁÉ‹¢›À˘rÿáﬁ“Êò˙o˙ôÓ∂ÂËÎPÓjÓkÓnÙs€ù€ÉÏ’Í’¸`‚ΩÿZÎ‡‹îÔÇ˜ÉÙçÎòŸ€ÿ±◊ôÔÄÙÖŸ¢Íu€Á„˚ﬁêËﬁÌ»ı…ı¢€|È“ıD¯r¸òˆæ¸É‚’˘KˆzËÿ⁄ó√ÒªÛÍÛ‘Û´Û•ÚËÚ—ÒÌÒ”';
  V_CHARW   VARCHAR2(4000) := 'Ê¥¸|ÿÙﬂúÎÌcÌÄ·ÀÓìÿ‡Ê˝‹πÿôÓBﬂê›∏Á∫Î‰›“Á˛Óµ›n€l‰jÂÜ‰[ÂsŸñÊ~⁄@ÿË„ØÈ˛’s›y˜ÕﬁÇŸÀÂ‘Íû⁄Ò›⁄Ï–ﬁ±˜òˆgˆh‡Ì€◊‡¯„Ì„«Ìf‰∂·°·Õﬂ`‡å·WÂÖÈùıdÏSÏTÏøÁ‚‰¢Ê∏⁄√⁄Û‚´Ù∫Ë∏ˆ€’Ü€cÌlÓQÂóınÌtÔ]Ì|Í¶‚¨÷^ÂMıKﬁEÁAÏG˜ù◊~‹Z◊à‹^ﬁdÿn›ò›ú˜óÊíˆÄˆì„”‚Üˆ©Ùï¯Y¯jÈèÈîÈö¸ïÍZÍ[ÿÿ„ÎÓÇË∑˚lÊf˙O›Óﬁ≥˝NŸ¡›´‡∏€bÎø·¢‰◊Ì“ˆª˝}€ÿ⁄˘⁄è‚E‡w’G’_¯åÊuˆÉ‡NﬂÌ‰¥˚c˘Mıà˜˘˙~ÿıÂ¸‚–‚Ë‚‰Â√ÍıÂq˘^‹Rÿ£˛@⁄„Ëª‹ÃﬂAÏ…ÊƒÎFÏ}ÊÂª’`ˆ»Îú˝HÏF˝I˙FƒÚÍÚ⁄ÙÌÕ';
  V_CHARX   VARCHAR2(4000) := 'Ÿ‚⁄¿€≠ﬂÒﬁ…‰ªÏ§‰¿›æ⁄T‚RÙ—Ù‚Ù∏‡qŸ“’OÿgFÊ“OÈÿÏ®Ï‰ÙÀÂaÿGÿHÿlÿâÎvıñ˘T◊@ıµÁ^Î^Íÿ·@˜˚˙†ËÑ‡EÍÍ⁄v⁄Ù÷êÊàÏI˜ûÔe˜@ÁÙ·„›ﬂ‚|ÂÔ›˚„äÏ˚÷L÷l€í˜^‹h‚æ€ß‡S‚M„“Ù™⁄iÏ˘⁄VÎK¸_Ù]ÍSÏUﬂ»ÿBÈiÔPˆy·ÚË‘ÍÉÌÃÍòÂ⁄Ë¶⁄YÙ†›†ÂíÊ_˜Ô˙TÈp’íÁ]ÎØÏÏÙÃ›≤Ëùı—ı£„îÂﬂÌÑÂvÂwÌÜır€ü◊]˙N‹]˜ÄÊµÈe„ï’tŸt÷P›ç·_˚y⁄DËv˙ë˙í˙öŸ˛·˝Íì⁄`ı–ÎUﬁ∫ÂÇÏﬁÓáÌ`Ô@·≠‹»Íà’^‰}ÂDÿR¸GÁoˆ±˝E‹º‡_‡l‡mÁΩ›Ÿ‡xÊ¯˚ë˜`ËÇ‚‘€K‚√˜œ„}AˆﬂıaıúÌë˜zÌóÁ}˜PË…ﬂÿË’ÊÁÁØÂ–˚^‰Ï€X‰N˜Ã¯{÷y¯ì˙j‡U·≈’q÷j’[˛MŸ…€ƒﬂ¢Á”÷CÌPËH◊ê˝öÁ•ŸÙ‰ÕÈ«ÈøÌÖ‚›‚≥ﬁØÂ‚€∆÷xÌCÂ¨˝^˝k˝K‹aıÛ‚‡ﬂîÍø›∑‚dÏß‰\‹∞ˆŒÙgÁÜÍcÿ∂‹åÓà·Ö÷_ıSˆ]⁄Í‡DËóÍÄÌ Ëô‚]„o„ã‰tﬂ©‹Ù„¨˛N‹∫◊õ◊úﬂ›‚”ı˜‚ „ñ˜€ÊTıx¯†ÊôÔq·∂‰Â‰PÁVÁn˝MÌÏÌπÁÔ◊†ÌöÌúÙq’ö÷ûÙzË`ÙP⁄ºËÚ‡ÜÙ⁄ıØ‰™€√‰”Ï„Ÿ[„Ñ˜rﬁ£‹é⁄ŒﬁÔ›ÊÍ—Ï”Ÿÿ’ù÷XÊM◊Xˆ~◊z‰ˆËØﬂx„˘Ï≈ÓÁ‰÷È∏„CÌ€Ô‡ÏúÔXÊõ⁄KﬁjÌYÌ¥˚`ıΩÎz˙õﬁG˜®˜L⁄ ⁄p÷o€˜‚¥ﬁπÍ÷ı∏·æ‚˛‰≠‰±‹˜‡âˆ‡˜S˜\·ﬂﬁôŸ„ﬂdŸbﬁ¶ÓöËR™ÛÔÛ„Û⁄Û¡Û≠Û¨Û£Ú·ÚπÒ„Ò∂ÔÁ¬º';
  V_CHARY   VARCHAR2(4000) := '—πË‚Ëõ¯fÂE¯Ü˘sÁåÿÛ·¨ÁÌ˝˝\Â¬€ÎÊ´ÌºÎ≤ﬁÎ˝Ö‚˚ÎŸ·√›Œ‰ŒÎÁ€≥ÊÃ·ZÈé¸i⁄•„∆Â˚‹æ‡IÈZÈêÈ‹ÓÅÓÜ˚í˚}˚öŸŸ≤Ÿ»ÿ…€±·DÁ¸ﬂVÎCÓª˜ ‹y¸dˆo˘û¸f˝d˝å¸j¸kÓõ˝BÙ|˜˙˝z¸sÍÃÍöÏÕ‰Ÿ¯Hı¶⁄›˜–¯e÷VÿÕÙe¯ë‡ùŸû‹Ç·z˙`⁄I⁄J◊Ö·Ä˙é·â◊óÿVÿW„Û„ZÎá˜±Â}¯ÑÍgÏæËñÔr·‡Ï»Íñ÷U›åÂê¯óÔ^Á{ˆuÏR˚F›IB‚ÛÌ¶Á€ÿ≤ﬂ∫¯^ÿ≥Î»È˜ÁÚ›U·Êﬂb„ìÔuÔüPÙÌ÷{÷|Êc˜•Ô_ÓñˆéË√· ¯ÄÈô˝o˙rÏâ˝GÍ◊˙_◊äËÄﬁﬁÓÙ‚X‰yÊU⁄˛ÌìÍ Ï«⁄À‡v‡íÿÃ÷]ÊEÊd˘wÏv˚Eﬁvﬂﬁ‚¢‡cÏ•‰Ù„û‡Ê˚p·t˜◊b˙s¸p€›⁄±‚˘Â∆‚¬ﬂ◊‹ËÍ›ﬁñÌÙÙ˝ŸO’B€DÌõÔçﬂzÓUÓV·⁄Ó{ık÷ñÁF◊Ç˚@ﬁ~Ó∆‹”ÙØ·êﬁ†‚r„i¯CÏΩ›}ÓâﬁT˝tﬂÆÿ◊ÿÓÍdÿ˝ﬂΩŸ´·ª‚¯Ê‰ﬁ»ﬁƒÙ‡ÈÛ„®ﬁ⁄ÿóÍã€¸ÿ[ÿ\‚NÎc⁄ò›W‚zÁÀÏàÏ⁄’xÔ◊˚k˚o¸]ÿÊÈÏﬁ≤ÙËÿäılŸìÊÑÔÓÿsÏJˆG˘Ä˘Å˘ã◊g◊h·y·{ËO˙^˙g‹≤˙Ö˙ú◊î˝~Íf‰¶Î≥ÍéÓ˜ÍîÍõ‡≥‹ß„üÏê÷NÎñÈûÎ†Ìê€Û·˛‚w˝á€¥‚π’z„yˆ∏ˆØ˝]˝l˙Å€»ﬂ≈‚Y‚iÔãÎLÏÇÔá⁄yÎ[◊ç‹·ÿ∑·Sıg›∫Á¯ÈA‡”ﬁ¸ŸaË¨Îõ¯ä‚ﬂÌåÊv˙D◊s˙LË]˙à‹Ö˙ó˚K˚W‹„‹˛›”È∫‰ﬁ›ˆ‰ÎŸ¯÷hÂ≠⁄A€´ÔIÓeÁçÎÙÏô◊G‡°Áﬂ‡{‹≠„º‰V€’‡aÔﬁÎtÁO˜´˜”˜I˙x‡ØÔJÓÑˆêŸ∏˜ë€xıó·kÿ¸ﬂœ˚~‡õﬁÃË÷›Ø›µﬁú‡]ﬂKﬂ[ˆœÈ‡‚ô˜Ü›jÙú›íıOﬂàÿ’›¨Ó‰BÎª˜ÓŸß‡ÛÂ∂ﬁîÿz·R’T˜¯Ê˙ﬁ}Í|ﬂéÊ•Ï£Ï∂ÙßÿÆÙ®·¸⁄ƒ·C‚≈›«‚DÍúˆßÙ~·ŒﬁÌÎÈË§ÍÏ’òÎkNÙà€u›õÂì÷~ıÇˆVˆi˙}˚CÿÒŸ∂‡Ù‡ˆ‚◊‡hËû’Z‰oˆπÿÖ˚á˝rÌ≤Â˝‚¿Í≈Ó⁄˛C⁄ÕﬂN„–ÔÑÏœ›˜‚ïÓAÿπ›h„ÉÎTﬂy‰`¯\Ï€÷IÂ[Èì¯É¯Ö¯àÙr·q˘O◊uﬁXÁüÏMÂ˜˜N˙ñ˚O‹ÜÙcÙdÌÛ˚g¯S‰ë¯x˘t¸å¸ê⁄Oﬂñ„‰Îºÿí·J‚ÉˆΩ‹´Ùí‡˜È⁄÷wﬁ@¸xÊÖﬂá˘†˙MﬂRﬂh€˘Ê¬ﬁÚË•ÓäÎæ‹ãÓ·⁄î‚_„XÈÜÈáÈ–ŸﬂÂÆ¸g‹S˚N˝õ˚V⁄SÓfŸöÁ°‹øÍ¿‡yÎÖÎµ‰]Ím·ÒÈÊ‚qÎEÏB˝q˝y€©„¢‡i„≥ﬂ\ËπÏŸŸÑ·d·jÌrÌyÌçÆ–ÈˆÛ¢ÚˆÚıÚÊÚ‚Ú’Ú ÚƒÚæÚ£Ò¡ÛÓÛ€ÛƒÛøÒøÒæÒ∫Ò¥ÒØÒ´Ò®˘ıÍ‡÷Œ¡∞';
  V_CHARZ   VARCHAR2(4000) := 'ÿ¥ÿ∆ÿ”ÿÎÿ˘Ÿ™ŸæŸÃŸﬁ⁄£⁄Ø⁄∫⁄¡⁄¬⁄—⁄ÿ⁄⁄⁄ﬁ⁄Ë⁄Ï⁄Ó€§€•€µ€∏€⁄€˙‹∆‹—‹Ô›ß›œ›Ëﬁ©ﬁ ﬁŸﬁÍﬁ¯ﬁ˝ﬂ°ﬂ§ﬂ™ﬂ¨ﬂ∏ﬂ∆ﬂÂﬂÓﬂﬂÚﬂıﬂ˘ﬂ˙‡˘‡˝·§·ø·Ã·—·÷·Á‚Ø‚Õ‚Â‚Ù„∑‰•‰®‰∑‰æ‰√‰ÛÂ™Â≈ÂÈÂÎÊ¢Ê®Ê—Ê‹Ê‡Ê„ÊÌÊÔÊ˚ÁßÁªÁƒÁ«Á’Á⁄ÁﬁË∞Ë∂ËÃËŒËœË◊ËŸË‰ËÂË˜Ë˛È´ÈªÈ∆ÈÕÈ◊ÈÚÈÙÈ˘È¸Í¢Í∞ÍµÍæÍ√ÍﬁÍﬂÍ‚Î∆Î–Î—Î”Î’ÎﬁÎÍÎ˘ÏπÏƒÏÌÏÒÏÛÏıÏ˙ÌßÌΩÌƒÌŒÌÿÌ›ÌÈÌˆÓ≥Ó¿Ó»Ó€Ó˘Ô£Ô≠Ô≈ÔﬂÔÌÔÒÔÙÔˆ°≤∫—‰ÊÎÒÒ©Ò∏ÒﬁÒËÚßÚ∆ÚŒÚÿÛÆÛØÛ√Û…Û Û–Û›ÛÂÛÁÛÙ¢Ù¶Ù±Ù∂Ù∑Ù“Ù’ÙÿÙ„ÙÍÙıÙ˜Ù¸ı•ı≈ıŸı‹ı‡ıÓıÚıÙı˛ˆ£ˆ§ˆ∑ˆ…ˆÌˆˆ˜Æ˜⁄˜Ê˜˛';
  FUNCTION F_NLSSORT(P_WORD IN VARCHAR2) RETURN VARCHAR2 AS
  BEGIN RETURN NLSSORT(P_WORD, 'NLS_SORT=SCHINESE_PINYIN_M'); END;
begin
 select count(*)  into a from dual  where userenv('LANGUAGE') like '%GBK%';
   
   if a =1 then
    
   BEGIN
      IF PRM_SPELL IS NULL OR LENGTH(TRIM(PRM_SPELL)) = 0 THEN
        SPELLCODE := '';
      ELSE
        INSPELL := UPPER(PRM_SPELL);
        dbms_output.put_line(INSPELL);
        SPELLCODE := '';
        FOR V_BITNUM IN 1 .. LENGTH(INSPELL) LOOP
          dbms_output.put_line(LENGTH(INSPELL));
          dbms_output.put_line(V_BITNUM);
          V_BITCHAR := SUBSTR(INSPELL, V_BITNUM, 1);
          dbms_output.put_line(V_BITCHAR);
          IF V_BITCHAR >= '∞°' AND V_BITCHAR <= '◊˘' THEN
            FOR V_CHRNUM IN 1 .. LENGTH(V_STDSTR) LOOP
              IF SUBSTR(V_STDSTR, V_CHRNUM, 1) = '-' THEN
                NULL;
              ELSIF V_BITCHAR < SUBSTR(V_STDSTR, V_CHRNUM, 1) THEN
                SPELLCODE := SPELLCODE || CHR(64 + V_CHRNUM);
                EXIT;
              END IF;
            END LOOP;
            IF V_BITCHAR >= '‘—' THEN
              SPELLCODE := SPELLCODE || 'Z';
            END IF;
          ELSIF ASCII(V_BITCHAR) < 256 THEN
            SPELLCODE := SPELLCODE || V_BITCHAR;
          ELSIF INSTR('¢Ò¢Ú¢Û¢Ù¢ı¢ˆ¢¯¢¯¢˘', V_BITCHAR) > 0 THEN
            SPELLCODE := SPELLCODE || CHR(ASCII(V_BITCHAR) - 41664);
          ELSIF INSTR('£¡£¬£√£ƒ£≈£∆£«£»£…£ £À£Ã£Õ£Œ£œ£–£—£“£”£‘£’£÷£◊£ÿ£Ÿ£⁄',
                      V_BITCHAR) > 0 THEN
            SPELLCODE := SpellCode || chr(ascii(v_BitChar) - 41856);
          ELSIF INSTR('¶°¶¡', V_BITCHAR) > 0 THEN
            SPELLCODE := SPELLCODE || 'A';
          ELSIF INSTR('¶¢¶¬', V_BITCHAR) > 0 THEN
            SPELLCODE := SPELLCODE || 'B';
          ELSIF INSTR('¶£¶√', V_BITCHAR) > 0 THEN
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

  FOR I IN 1 .. NVL(LENGTH(PRM_SPELL), 0) LOOP  
V_COMPARE := lower((SUBSTR(PRM_SPELL, I, 1)));
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
V_COMPARE := F_NLSSORT(SUBSTR(PRM_SPELL, I, 1));
  IF V_COMPARE >= F_NLSSORT('ﬂπ') AND V_COMPARE <= F_NLSSORT('Úà') THEN V_RETURN := V_RETURN || 'a';
    ELSIF PRM_SPELL = '––' THEN
      V_RETURN := 'h';
    ELSIF V_COMPARE >= F_NLSSORT('∞À') AND V_COMPARE <= F_NLSSORT('≤æ') THEN
      V_RETURN := V_RETURN || 'b';
    ELSIF V_COMPARE >= F_NLSSORT('‡Í') AND V_COMPARE <= F_NLSSORT('Âe') THEN
      V_RETURN := V_RETURN || 'c';
    ELSIF V_COMPARE >= F_NLSSORT('Öˆ') AND V_COMPARE <= F_NLSSORT('˘z') THEN
      V_RETURN := V_RETURN || 'd';
    ELSIF V_COMPARE >= F_NLSSORT('ää') AND V_COMPARE <= F_NLSSORT('òﬁ') THEN
      V_RETURN := V_RETURN || 'e';
    ELSIF V_COMPARE >= F_NLSSORT('∑¢') AND V_COMPARE <= F_NLSSORT('™g') THEN
      V_RETURN := V_RETURN || 'f';
    ELSIF V_COMPARE >= F_NLSSORT('Í∏') AND V_COMPARE <= F_NLSSORT('ƒB') THEN
      V_RETURN := V_RETURN || 'g';
    ELSIF V_COMPARE >= F_NLSSORT('äo') AND V_COMPARE <= F_NLSSORT('â˛') THEN
      V_RETURN := V_RETURN || 'h';
    ELSIF V_COMPARE >= F_NLSSORT('ÿ¢') AND V_COMPARE <= F_NLSSORT('îh') THEN
      V_RETURN := V_RETURN || 'j';
    ELSIF V_COMPARE >= F_NLSSORT('ﬂ«') AND V_COMPARE <= F_NLSSORT('∑i') THEN
      V_RETURN := V_RETURN || 'k';
    ELSIF V_COMPARE >= F_NLSSORT('¿¨') AND V_COMPARE <= F_NLSSORT('î^') THEN
      V_RETURN := V_RETURN || 'l';
    ELSIF V_COMPARE >= F_NLSSORT('á`') AND V_COMPARE <= F_NLSSORT('ó“') THEN
      V_RETURN := V_RETURN || 'm';
    ELSIF V_COMPARE >= F_NLSSORT('íÇ') AND V_COMPARE <= F_NLSSORT('Øë') THEN
      V_RETURN := V_RETURN || 'n';
    ELSIF V_COMPARE >= F_NLSSORT('πp') AND V_COMPARE <= F_NLSSORT('ùa') THEN
      V_RETURN := V_RETURN || 'o';
    ELSIF V_COMPARE >= F_NLSSORT('är') AND V_COMPARE <= F_NLSSORT('∆ÿ') THEN
      V_RETURN := V_RETURN || 'p';
    ELSIF V_COMPARE >= F_NLSSORT('∆ﬂ') AND V_COMPARE <= F_NLSSORT('—d') THEN
      V_RETURN := V_RETURN || 'q';
    ELSIF V_COMPARE >= F_NLSSORT('Åí') AND V_COMPARE <= F_NLSSORT('˙U') THEN
      V_RETURN := V_RETURN || 'r';
    ELSIF V_COMPARE >= F_NLSSORT('ÿÌ') AND V_COMPARE <= F_NLSSORT('ŒR') THEN
      V_RETURN := V_RETURN || 's';
    ELSIF V_COMPARE >= F_NLSSORT('Ç@') AND V_COMPARE <= F_NLSSORT('ªX') THEN
      V_RETURN := V_RETURN || 't';
    ELSIF V_COMPARE >= F_NLSSORT('å‹') AND V_COMPARE <= F_NLSSORT('˙F') THEN
      V_RETURN := V_RETURN || 'w';
    ELSIF V_COMPARE >= F_NLSSORT('œ¶') AND V_COMPARE <= F_NLSSORT('ËR') THEN
      V_RETURN := V_RETURN || 'h';
    ELSIF V_COMPARE >= F_NLSSORT('—æ') AND V_COMPARE <= F_NLSSORT('Ìç') THEN
      V_RETURN := V_RETURN || 'y';
    ELSIF V_COMPARE >= F_NLSSORT('éâ') AND V_COMPARE <= F_NLSSORT('Ö¯') THEN
      V_RETURN := V_RETURN || 'z';
    END IF;
    end if;
  END LOOP;
  RETURN V_RETURN;
END;
end if;
end;
/