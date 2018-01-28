#!/usr/bin/env bats

@test "HTTP one.example.com returns 200 OK" {
  run curl -L -s -o /dev/null -w "%{http_code}" http://one.example.com
  [[ $output = "200" ]]
}

@test "one.example.com can be installed" {
  run curl -L -s http://one.example.com
  [[ $output =~ "WordPress &rsaquo; Installation" ]]
}

@test "install one.example.com and check if is working" {
  run docker exec -ti one.example.com_php sh -c "php /code/wp-admin/wp-cli.phar --allow-root core install --url=\"one.example.com\" --title=\"one\" --admin_user=\"one\" --admin_password=\"one\" --admin_email=\"mail@one.example.com\" --skip-email"
  run curl -L -s http://one.example.com
  [[ $output =~ "<h1 class=\"site-title\"><a href=\"http://one.example.com/\" rel=\"home\">one</a></h1>" ]]
  [[ $output =~ "Just another WordPress site" ]]
}

@test "HTTP two.example.com returns 200 OK" {
  run curl -L -s -o /dev/null -w "%{http_code}" http://two.example.com
  [[ $output = "200" ]]
}

@test "two.example.com can be installed" {
  run curl -L -s http://two.example.com
  [[ $output =~ "WordPress &rsaquo; Installation" ]]
}

@test "install two.example.com and check if is working" {
  run docker exec -ti two.example.com_php sh -c "php /code/wp-admin/wp-cli.phar --allow-root core install --url=\"two.example.com\" --title=\"two\" --admin_user=\"two\" --admin_password=\"two\" --admin_email=\"mail@two.example.com\" --skip-email"
  run curl -L -s http://two.example.com
  [[ $output =~ "<h1 class=\"site-title\"><a href=\"http://two.example.com/\" rel=\"home\">two</a></h1>" ]]
  [[ $output =~ "Just another WordPress site" ]]
}
