console = Nizbel::Category.where(:title => 'Console').first
movies = Nizbel::Category.where(:title => 'Movies').first
music = Nizbel::Category.where(:title => 'Music').first
apps = Nizbel::Category.where(:title => 'Apps').first
tv = Nizbel::Category.where(:title => 'TV').first
xxx = Nizbel::Category.where(:title => 'XXX').first
other = Nizbel::Category.where(:title => 'Other').first

Nizbel::Group.unscoped.each do |group|
  categories = Set.new

  categories << tv if /alt\.binaries\.classic\.tv.*?|alt\.binaries\.ipod\.videos\.tvshows|alt\.binaries\.tv\.swedish|alt\.binaries\.mma|alt\.binaries\.multimedia\.sports/i =~ group.name
  categories << apps if /alt\.binaries\.b4e|alt\.binaries\.e-book*?|alt\.binaries\.cd.image|alt\.binaries\.audio\.warez|alt\.binaries\.games|alt\.binaries\.mac|linux|alt\.binaries\.warez\.smartphone|inner\-sanctum/i =~ group.name
  categories << other if /anime|alt\.binaries\.comics.*?/i =~ group.name
  categories << music if /lossless|flac|alt\.binaries\.sounds.*?|alt\.binaries\.mp3.*?|alt\.binaries\..*\.mp3|alt\.binaries\.mpeg\.video\.music/i =~ group.name
  categories << console if /alt\.binaries\.console.ps3|alt\.binaries\.games\.wii|alt\.binaries\.sony\.psp|alt\.binaries\.nintendo\.ds|alt\.binaries\.games\.nintendods/i =~ group.name
  categories << xxx if /alt\.binaries\.erotica\.divx|erotica/i =~ group.name
  categories += [console, tv, movies] if /alt\.binaries\.games\.xbox*/i =~ group.name
  categories += [xxx, tv, movies] if /alt\.binaries\.dvd.*?|alt\.binaries\.hdtv*|alt\.binaries\.x264|wmvhd/i =~ group.name
  categories += [xxx, movies, console, apps] if /alt\.binaries\.cores.*?/i =~ group.name
  categories += [console, apps, movies, music] if /alt\.binaries\.ath/i =~ group.name
  categories += [xxx, tv] if /alt\.binaries\.documentaries|alt\.binaries\.(teevee|multimedia|tv|tvseries)/i =~ group.name
  categories += [console, apps, xxx, other, tv] if /alt\.binaries\.warez\.ibm\-pc\.0\-day|alt\.binaries\.warez/i =~ group.name
  categories += [console, xxx, tv, movies] if /alt\.binaries\.movies\.xvid|alt\.binaries\.movies\.divx|alt\.binaries\.movies/i =~ group.name

  group.categories = categories.to_a
end