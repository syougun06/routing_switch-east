Before('@sudo') do
  fail 'sudo authentication failed' unless system 'sudo -v'
  @aruba_timeout_seconds = 15
end

After('@sudo') do
  run 'trema killall RoutingSwitch'
  sleep 10
end

Before('@rest_api') do
  fail 'sudo authentication failed' unless system 'sudo -v'
  @aruba_timeout_seconds = 15
end

After('@rest_api') do
  run 'trema killall RoutingSwitch'
  sleep 10
end

After('@rack') do
  cd('.') do
    rack_pid = IO.read('rack.pid').chomp
    run "kill #{rack_pid}"
  end
end
