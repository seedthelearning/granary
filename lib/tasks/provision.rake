desc "Deploy Granary"
task :deploy do
  `warble`
  `scp granary.war root@granary:/var/lib/tomcat6/webapps/granary.war`
end
