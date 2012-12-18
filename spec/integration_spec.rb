require 'open3'

describe "integration", slow: true do
  it "passes sample client implementation" do
    begin
      server_in, server_out, server_wait_thr = Open3.popen2e('ruby app.rb')
      client_out_str, client_status = Open3.capture2e('cd spec/bin && ./followermaze.sh')

      client_status.should be_success
      Process.kill("INT", server_wait_thr[:pid])
      server_wait_thr.value.should be_success
    ensure
      server_in.close
      server_out.close
    end
  end
end
