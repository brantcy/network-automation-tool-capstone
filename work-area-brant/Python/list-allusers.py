import active_directory
for user in active_directory.search ("objectCategory='Person'", "objectClass='User'"):
  print user

#
# or
#
for user in active_directory.search (objectCategory='Person', objectClass='User'):
  print user