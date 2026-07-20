# Chat Cursor seed data

puts "Creating seed data..."

admin = User.find_or_create_by!(username: "admin") do |u|
  u.password = "1234"
  u.password_confirmation = "1234"
  u.admin = true
end
admin.update!(admin: true) unless admin.admin?

guest = User.find_or_create_by!(username: "guest") do |u|
  u.password = "1234"
  u.password_confirmation = "1234"
end

general = Room.find_or_create_by!(name: "general") do |r|
  r.description = "자유롭게 이야기하는 공간입니다"
end

dev = Room.find_or_create_by!(name: "dev") do |r|
  r.description = "개발 관련 대화"
end

unless general.messages.exists?
  general.messages.create!(user: admin, body: "Chat Cursor에 오신 것을 환영합니다! 👋")
  general.messages.create!(user: guest, body: "안녕하세요, 테스트 메시지입니다.")
end

puts "Seed complete!"
puts "  Users: admin / 1234, guest / 1234"
puts "  Rooms: general, dev"
