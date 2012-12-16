{
  'Console' => [
    'NDS', 'PS2', 'PS3', 'PSP', 'Wii', 'Xbox', 'Xbox360'
  ],
  'Movies' => [
    '3D', 'DVD', 'Foreign', 'Other', 'WMV-HD', 'XviD', 'x264'
  ],
  'Music' => [
    'MP3', 'Flac', 'Video'
  ],
  'Apps' => [
    '0-Day', 'Android', 'eBook', 'iOS', 'ISO', 'Mac', 'Phone'
  ],
  'TV' => [
    'BoxHD', 'BoxSD', 'DVD', 'Foreign', 'HD', 'SD', 'Other'
  ],
  'XXX' => [
    'Clip', 'DVD', 'Pack', 'XviD', 'x264', 'Imageset'
  ],
  'Other' => [
    'Misc'
  ]
}.each do |category, sub_categories|
  parent = Nizbel::Category.create(:title => category)
  sub_categories.each do |sub|
    child = Nizbel::Category.new(:title => sub)
    child.parent = parent
    child.save
  end
end