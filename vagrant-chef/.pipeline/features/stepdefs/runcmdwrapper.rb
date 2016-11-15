#OK
require "net/ssh"

class RunCmdWrapper
    attr_reader :last_cmd_output
    attr_accessor :base_directory

    def initialize(args = {})
        @host = args[:host_name] || 'localhost'
        ssh_opts = args.dup
        invalid_args = ssh_opts.keys - Net::SSH::VALID_OPTIONS
        if ! invalid_args.empty?
            raise "FAILED invalid net-ssh options: [#{invalid_args.join(', ')}]"
        end

        @ssh = Net::SSH.start(nil, nil, ssh_opts) if ssh_opts[:host_name]
    end

    def run(cmd)
        run_cmd = (@base_directory ? "cd #{@base_directory} && " : "") + cmd + " 2>&1"
        @last_cmd_output = (@ssh ? run_remote(run_cmd) : run_local(run_cmd))
    end
 
    ##################################################################################
    private 

    def run_local(cmd)
        stdout_data = `#{cmd}`
        exit_code = $?.exitstatus
        raise "FAILED host: #{@host}\nreturn code: #{exit_code}\ndir: #{@base_directory}\ncmd: #{cmd}\noutput: #{stdout_data}" unless exit_code == 0
        return stdout_data
    end

    # Stolen from http://stackoverflow.com/a/3386375
    def run_remote(cmd)
        stdout_data = ""
        exit_code = nil

        @ssh.open_channel do |channel|
            channel.exec(cmd) do |ch, success|
                unless success
                    abort "FAILED: couldn't execute command (ssh.channel.exec)"
                end
                channel.on_data do |ch,data|
                    stdout_data+=data
                end

                channel.on_request("exit-status") do |ch,data|
                    exit_code = data.read_long
                end
            end
        end

        @ssh.loop
        raise "FAILED host: #{@host}\nreturn code: #{exit_code}\ncmd: #{cmd}\noutput: #{stdout_data}" unless exit_code == 0
        return stdout_data
    end
end
