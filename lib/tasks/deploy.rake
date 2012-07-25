desc "Deploy Granary"
task :deploy do
  puts 'Backing up production database...'
  sh('ssh root@granary mv /var/lib/tomcat6/webapps/granary/WEB-INF/db/neo4j-production /root')
  puts 'Building .war file...'
  sh('warble')
  puts 'Uploading .war file...'
  sh('scp granary.war root@granary:/var/lib/tomcat6/webapps/granary.war')
  puts 'Restarting Tomcat'
  sh('ssh root@granary service tomcat6 restart')
  puts 'Restoring production database...'
  sh('ssh root@granary mv /root/neo4j-production /var/lib/tomcat6/webapps/granary/WEB-INF/db/')
end
