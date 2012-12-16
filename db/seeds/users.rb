admin = Nizbel::User.new(
  :email => 'change@me.now',
  :password => 'Nizbel98',
  :password_confirmation => 'Nizbel98'
)
admin.username = 'admin'
admin.role = Nizbel::User::Roles::ADMIN
admin.save!