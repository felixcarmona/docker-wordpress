#!/usr/bin/env bats

@test "http request redirects to https (domain + www.domain)" {
  run curl -s -o /dev/null -w "%{http_code}" http://one.example.com
  [[ $output = "301" ]]

  run curl -s -o /dev/null -w "%{redirect_url}" http://one.example.com
  [[ $output = "https://one.example.com/" ]]

  run curl -s -o /dev/null -w "%{http_code}" http://www.one.example.com
  [[ $output = "301" ]]

  run curl -s -o /dev/null -w "%{redirect_url}" http://www.one.example.com
  [[ $output = "https://www.one.example.com/" ]]
}

@test "https works with www. and without www." {
  run curl -L -s -k -o /dev/null -w "%{http_code}" https://one.example.com
  [[ $output = "200" ]]

  run curl -L -s -k -o /dev/null -w "%{http_code}" https://www.one.example.com
  [[ $output = "200" ]]
}

@test "can be installed" {
  run curl -L -s -k https://one.example.com
  [[ $output =~ "WordPress &rsaquo; Installation" ]]

  run docker exec -ti one.example.com_php sh -c "php /code/wp-admin/wp-cli.phar --allow-root core install --url=\"one.example.com\" --title=\"one\" --admin_user=\"one\" --admin_password=\"one\" --admin_email=\"mail@one.example.com\" --skip-email"

  run curl -L -s -k https://one.example.com
  [[ $output =~ "<h1 class=\"site-title\"><a href=\"https://one.example.com/\" rel=\"home\">one</a></h1>" ]]
  [[ $output =~ "Just another WordPress site" ]]
}

@test "set permalinks" {
  run docker exec -ti one.example.com_php sh -c "php /code/wp-admin/wp-cli.phar --allow-root rewrite structure '/%postname%/'"

  run curl -L -s -k https://one.example.com/hello-world/
  [[ $output =~ "<title>Hello world! &#8211; one</title>" ]]
}

@test "edit post without W3 Total Cache will not invalidate the cache" {
  run curl -L -s -k https://one.example.com/hello-world/
  [[ $output =~ "Welcome to WordPress. This is your first post. Edit or delete it, then start writing!" ]]

  run docker exec -ti one.example.com_php sh -c "EDITOR='sed -i s/Welcome/Bienvenido/g' php /code/wp-admin/wp-cli.phar --allow-root post edit 1"
  run curl -L -s -k https://one.example.com/hello-world/
  [[ $output =~ "Welcome to WordPress. This is your first post. Edit or delete it, then start writing!" ]]

  run docker exec -ti one.example.com_php sh -c "EDITOR='sed -i s/Bienvenido/Welcome/g' php /code/wp-admin/wp-cli.phar --allow-root post edit 1"
  run curl -L -s -k https://one.example.com/hello-world/
  [[ $output =~ "Welcome to WordPress. This is your first post. Edit or delete it, then start writing!" ]]
}

@test "edit post with W3 Total Cache will invalidate the cache" {
  run docker exec -ti one.example.com_php sh -c "php /code/wp-admin/wp-cli.phar --allow-root plugin activate w3-total-cache"
  run docker exec -ti one.example.com_php sh -c "php /code/wp-admin/wp-cli.phar --allow-root w3-total-cache option set varnish.servers varnish"
  run docker exec -ti one.example.com_php sh -c "php /code/wp-admin/wp-cli.phar --allow-root w3-total-cache option set varnish.enabled 1"

  run curl -L -s -k https://one.example.com/hello-world/
  [[ $output =~ "Welcome to WordPress. This is your first post. Edit or delete it, then start writing!" ]]

  run docker exec -ti one.example.com_php sh -c "EDITOR='sed -i s/Welcome/Bienvenido/g' php /code/wp-admin/wp-cli.phar --allow-root post edit 1"
  run curl -L -s -k https://one.example.com/hello-world/
  [[ $output =~ "Bienvenido to WordPress. This is your first post. Edit or delete it, then start writing!" ]]

  run docker exec -ti one.example.com_php sh -c "EDITOR='sed -i s/Bienvenido/Welcome/g' php /code/wp-admin/wp-cli.phar --allow-root post edit 1"
  run curl -L -s -k https://one.example.com/hello-world/
  [[ $output =~ "Welcome to WordPress. This is your first post. Edit or delete it, then start writing!" ]]
}

@test "two.example.com doesn't interfere with one.example.com" {
  run docker exec -ti two.example.com_php sh -c "php /code/wp-admin/wp-cli.phar --allow-root core install --url=\"two.example.com\" --title=\"two\" --admin_user=\"two\" --admin_password=\"two\" --admin_email=\"mail@two.example.com\" --skip-email"

  run curl -L -s -k https://one.example.com
  [[ $output =~ "<h1 class=\"site-title\"><a href=\"https://one.example.com/\" rel=\"home\">one</a></h1>" ]]

  run curl -L -s -k https://www.one.example.com
  [[ $output =~ "<h1 class=\"site-title\"><a href=\"https://one.example.com/\" rel=\"home\">one</a></h1>" ]]
  
  run curl -L -s -k https://two.example.com
  [[ $output =~ "<h1 class=\"site-title\"><a href=\"https://two.example.com/\" rel=\"home\">two</a></h1>" ]]

  run curl -L -s -k https://www.two.example.com
  [[ $output =~ "<h1 class=\"site-title\"><a href=\"https://two.example.com/\" rel=\"home\">two</a></h1>" ]]
}