import active_directory
me = active_directory.find_user () # defaults to current user
for group in me.memberOf:
  print "Members of group", group.cn
  for group_member in group.member:
    print "  ", group_member