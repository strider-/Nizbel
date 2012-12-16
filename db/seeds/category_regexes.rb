{
  'Console.NDS' => [/NDS/],
  'Console.PS2' => [/PS2?\-/],
  'Console.PS3' => [/PS3?\-/],
  'Console.PSP' => [/PSP?\-/i],
  'Console.Wii' => [/WII|WIIWARE|WII.*?VC|VC.*?WII|WII.*?DLC|DLC.*?WII|WII.*?CONSOLE|CONSOLE.*?WII/i],
  'Console.Xbox' => [/xbox/i],
  'Console.Xbox360' => [/XBOX360|x360|(DLC.*?xbox360|xbox360.*?DLC|XBLA.*?xbox360|xbox360.*?XBLA)/i],
  'Movies.3D' => [/3d|hsbs|h\-sbs/i],
  'Movies.DVD' => [/(dvdscr|dvdrip|r5|\.CAM|dvdr|dvd9|divx)[\.\-]/i],
  'Movies.Foreign' => [
    /(danish|flemish|Deutsch|dutch|nl\.?subbed|nl\.?sub|\.NL|swedish|swesub|french|german|spanish)[\.\-]/i,
    /NLSubs|NL\-Subs|NLSub|\d{4} German|Deutsch| der /i
  ],
  'Movies.Other' => [/bd?25|bd?50|vc-1|avc|extrascene/i],
  'Movies.WMV-HD' => [/wmvhd|wmv|vc1/i],
  'Movies.XviD' => [/xvid|xvidhd|web-dl/i],
  'Movies.x264' => [/x264|bluray\-|blu-ray/i],
  'Music.MP3' => [/Greatest_Hits|VA?(\-|_)|WEB\-\d{4}/i],
  'Music.Flac' => [/Lossless|FLAC/i],
  'Music.Video' => [/x264|wmv|dvdr|dvd9/i],
  'Apps.0-Day' => [
    /[\.\-_ ](x32|x64|x86|win64|winnt|win9x|win2k|winxp|winnt2k2003serv|win9xnt|win9xme|winnt2kxp|win2kxp|win2kxp2k3|keygen|regged|keymaker|winall|win32|template|Patch|GAMEGUiDE|unix|irix|solaris|freebsd|hpux|linux|windows|multilingual|software|Pro v\d{1,3})[\.\-_ ]/i,
    /\-SUNiSO|Adobe|CYGNUS|GERMAN\-|v\d{1,3}.*?Pro|MULTiLANGUAGE|Cracked|lz0|\-BEAN|MultiOS|\-iNViSiBLE|\-SPYRAL|WinAll|Keymaker|Keygen|Lynda\.com|FOSI|Keyfilemaker|DIGERATI|\-UNION/i
  ],
  'Apps.Android' => [/android/i],
  'Apps.eBook' => [/Ebook|E?\-book|\) WW|\[Springer\]|Publishing/i],
  'Apps.iOS' => [/i(pod|phone|pad)/i],
  'Apps.ISO' => [/\-RELOADED|\-SKIDROW|PC GAME|FASDOX|games|v\d{1,3}.*?\-TE|RIP\-unleashed|Razor1911/i],
  'Apps.Mac' => [/osx|os\.x|\.mac\./i],
  'Apps.Phone' => [
    /[\.\-_](IPHONE|ITOUCH|ANDROID|COREPDA|symbian|xscale|wm5|wm6)[\.\-_]/i,
    /IPHONE|ITOUCH|IPAD|ANDROID|COREPDA|symbian|xscale|wm5|wm6/i
  ],
  'TV.BoxHD' => [/bluray|blu-ray/i],
  'TV.BoxSD' => [/dvdrip/i],
  'TV.DVD' => [/dvdr/i],
  'TV.Foreign' => [
    /(danish|flemish|dutch|Deutsch|nl\.?subbed|nl\.?sub|\.NL\.|swedish|swesub|french|german|spanish)[\.\-]/i,
    /NLSubs|NL\-Subs|NLSub|Deutsch| der |German| NL /i
  ],
  'TV.HD' => [/x264|1080|720|h\.?264|web\-?dl|wmvhd|trollhd/i],
  'TV.SD' => [/dvdr|dvd5|dvd9|xvid/i],
  'TV.Other' => [
    /(S?(\d{1,2})\.?(E|X|D)(\d{1,2})[\. _-]+)|(dsr|pdtv|hdtv)[\.\-_]/i,
    /(\.S\d{2}\.|\.S\d{2}|\.EP\d{1,2}\.|trollhd)/i
  ],
  'XXX.Clip' => [/wmv|pack\-|mp4|f4v|flv|mov|mpeg|isom|realmedia|multiformat|(e\d{2,})|(\d{2}\.\d{2}\.\d{2})|(issue\.\d{2,})/i],
  'XXX.DVD' => [/dvdr[^ip]|dvd5|dvd9/i],
  'XXX.Pack' => [/pack|uhq|u4all/i],
  'XXX.XviD' => [/xvid|dvdrip|bdrip|brrip|pornolation|swe6|nympho|detoxication|tesoro/i],
  'XXX.x264' => [/x264/i],
  'XXX.Imageset' => [/imageset/i],
  'Other.Misc' => [],
  'Other.Comics' => [/\.cbr|\.cbz/i],
  'Other.Anime' => []
}.each do |cat,rxs|
  p_name, c_name = cat.split('.')
  category = Nizbel::Category.joins("JOIN nizbel_categories AS p ON p.id = nizbel_categories.parent_id")
                             .where('p.title = ? AND nizbel_categories.title = ?', p_name, c_name).first

  rxs.each do |r|
    rec = Nizbel::ReleaseRegex.from_php_regex(r.inspect)
    rec.category = category
    rec.save!
  end
end