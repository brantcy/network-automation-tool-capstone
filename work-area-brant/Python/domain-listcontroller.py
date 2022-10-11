import active_directory
for master in active_directory.root ().masteredBy:
  print master.Parent.dNSHostName