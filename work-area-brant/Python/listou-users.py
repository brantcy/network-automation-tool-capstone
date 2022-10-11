import active_directory
users = active_directory.AD_object ("LDAP://ou=Users,dc=com,dc=example")
for user in users.search (objectCategory='Person'):
  print user