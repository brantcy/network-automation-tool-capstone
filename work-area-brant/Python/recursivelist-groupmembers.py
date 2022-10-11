import active_directory

domain_admins = active_directory.find_group ("Domain Admins")
all_users = set ()
for group, groups, users in domain_admins.walk ():
  all_users.update (users)

for user in all_users:
  print user