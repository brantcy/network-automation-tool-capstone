import active_directory
me = active_directory.find_user ()
for group in me.memberOf:
  print "Group types for", group.cn, ":", ", ".join (group.groupType)