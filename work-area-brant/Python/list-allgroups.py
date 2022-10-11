import active_directory
for group in active_directory.search (objectClass='group'):
  print group.cn