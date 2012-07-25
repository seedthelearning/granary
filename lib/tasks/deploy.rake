desc "Deploy Granary"
task :deploy do
  puts 'Building .war file...'
  sh('warble')
  puts 'Uploading .war file...'
  sh('scp granary.war root@granary:/var/lib/tomcat6/webapps/granary.war')
  puts 'Restarting Tomcat'
  sh('ssh root@granary service tomcat6 restart')
end
