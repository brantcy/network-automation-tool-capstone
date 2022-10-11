import active_directory
user = active_directory.find_user ()
print "User:", user.cn
for group in user.memberOf:
  print "  ", group