#!/usr/bin/env bats

@test "HTTP one.example.com returns 200 OK" {
  run curl -L -s -o /dev/null -w "%{http_code}" http://one.example.com
  [[ $output = "200" ]]
}

@test "HTTP one.example.com shows installation screen" {
  run curl -L -s http://one.example.com
  [[ $output =~ "WordPress &rsaquo; Installation" ]]
}

@test "HTTP two.example.com returns 200 OK" {
  run curl -L -s -o /dev/null -w "%{http_code}" http://two.example.com
  [[ $output = "200" ]]
}

@test "HTTP two.example.com shows installation screen" {
  run curl -L -s http://two.example.com
  [[ $output =~ "WordPress &rsaquo; Installation" ]]
}
