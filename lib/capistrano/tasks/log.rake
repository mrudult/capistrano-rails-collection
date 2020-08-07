namespace :logs do
  desc "Tail log files"
  task :tail do
    on roles(:app) do
      trap("INT") { puts 'Interupted'; exit 0; }
      execute "tail -f #{shared_path}/log/#{fetch(:rails_env)}.log" do |channel, stream, data|
        puts  # for an extra line break before the host name
        puts "#{channel[:host]}: #{data}"
        break if stream == :err
      end
    end
  end

  desc "Tail log files"
  namespace :tail do
    task :sidekiq do
      on roles(:app) do
        trap("INT") { puts 'Interupted'; exit 0; }
        execute "tail -f #{shared_path}/log/sidekiq.log" do |channel, stream, data|
          puts  # for an extra line break before the host name
          puts "#{channel[:host]}: #{data}"
          break if stream == :err
        end
      end
    end

    namespace :unicorn do
      task :stderr do
        on roles(:app) do
          trap("INT") { puts 'Interupted'; exit 0; }
          execute "tail -f #{shared_path}/log/unicorn.stderr.log" do |channel, stream, data|
            puts  # for an extra line break before the host name
            puts "#{channel[:host]}: #{data}"
            break if stream == :err
          end
        end
      end

      task :stdout do
        on roles(:app) do
          trap("INT") { puts 'Interupted'; exit 0; }
          execute "tail -f #{shared_path}/log/unicorn.stdout.log" do |channel, stream, data|
            puts  # for an extra line break before the host name
            puts "#{channel[:host]}: #{data}"
            break if stream == :err
          end
        end
      end
    end
  end
end